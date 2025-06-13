import 'dart:async';
import 'package:flutter/material.dart';

import '../../models/recipe.dart';
class BrewTimer extends StatefulWidget {
  final Recipe recipe;
  final VoidCallback onBack;

  const BrewTimer({
    Key? key,
    required this.recipe,
    required this.onBack,
  }) : super(key: key);

  @override
  State<BrewTimer> createState() => _BrewTimerState();
}

class _BrewTimerState extends State<BrewTimer> {
  Timer? _timer;
  int _currentStepIndex = 0;
  int _stepTimeRemaining = 0;
  int _totalTimeElapsed = 0;
  bool _isRunning = false;
  bool _isPaused = false;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initializeTimer() {
    if (widget.recipe.steps.isNotEmpty) {
      _stepTimeRemaining = widget.recipe.steps[0].durationSeconds;
    }
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _totalTimeElapsed++;
        _stepTimeRemaining--;

        if (_stepTimeRemaining <= 0) {
          _moveToNextStep();
        }
      });
    });
  }

  void _pauseTimer() {
    setState(() {
      _isPaused = true;
      _isRunning = false;
    });
    _timer?.cancel();
  }

  void _resumeTimer() {
    _startTimer();
  }

  void _stopTimer() {
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _currentStepIndex = 0;
      _totalTimeElapsed = 0;
      _isCompleted = false;
    });
    _timer?.cancel();
    _initializeTimer();
  }

  void _moveToNextStep() {
    if (_currentStepIndex < widget.recipe.steps.length - 1) {
      setState(() {
        _currentStepIndex++;
        _stepTimeRemaining = widget.recipe.steps[_currentStepIndex].durationSeconds;
      });
    } else {
      setState(() {
        _isCompleted = true;
        _isRunning = false;
      });
      _timer?.cancel();
    }
  }

  void _skipToStep(int stepIndex) {
    if (!_isRunning && !_isPaused) {
      setState(() {
        _currentStepIndex = stepIndex;
        _stepTimeRemaining = widget.recipe.steps[stepIndex].durationSeconds;
        _isCompleted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        title: Text(widget.recipe.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _stopTimer,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTimerDisplay(),
            const SizedBox(height: 24),
            _buildCurrentStep(),
            const SizedBox(height: 24),
            _buildControlButtons(),
            const SizedBox(height: 24),
            Expanded(child: _buildStepsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerDisplay() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              _formatTime(_stepTimeRemaining),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: _stepTimeRemaining <= 10 && _isRunning
                    ? Colors.red
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Step ${_currentStepIndex + 1} of ${widget.recipe.steps.length}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: widget.recipe.steps.isNotEmpty
                  ? (_currentStepIndex + 1) / widget.recipe.steps.length
                  : 0,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              'Total: ${_formatTime(_totalTimeElapsed)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    if (widget.recipe.steps.isEmpty) {
      return const SizedBox.shrink();
    }

    final currentStep = widget.recipe.steps[_currentStepIndex];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (_isCompleted) ...[
              Icon(
                Icons.check_circle,
                size: 48,
                color: Colors.green,
              ),
              const SizedBox(height: 12),
              Text(
                'Brewing Complete!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enjoy your coffee!',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ] else ...[
              Text(
                'Step ${_currentStepIndex + 1}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                currentStep.instruction,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildControlButtons() {
    if (_isCompleted) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FilledButton.icon(
            onPressed: _stopTimer,
            icon: const Icon(Icons.refresh),
            label: const Text('Brew Again'),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (!_isRunning && !_isPaused)
          FilledButton.icon(
            onPressed: _startTimer,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start'),
          ),
        if (_isRunning)
          FilledButton.icon(
            onPressed: _pauseTimer,
            icon: const Icon(Icons.pause),
            label: const Text('Pause'),
          ),
        if (_isPaused)
          FilledButton.icon(
            onPressed: _resumeTimer,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Resume'),
          ),
        if (_isRunning || _isPaused)
          OutlinedButton.icon(
            onPressed: _stopTimer,
            icon: const Icon(Icons.stop),
            label: const Text('Reset'),
          ),
        if (_isRunning || _isPaused)
          OutlinedButton.icon(
            onPressed: _moveToNextStep,
            icon: const Icon(Icons.skip_next),
            label: const Text('Skip'),
          ),
      ],
    );
  }

  Widget _buildStepsList() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'All Steps',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.recipe.steps.length,
              itemBuilder: (context, index) {
                final step = widget.recipe.steps[index];
                final isCurrentStep = index == _currentStepIndex;
                final isPastStep = index < _currentStepIndex;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isPastStep
                        ? Colors.green
                        : isCurrentStep
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surfaceVariant,
                    foregroundColor: isPastStep || isCurrentStep
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    child: isPastStep
                        ? const Icon(Icons.check, size: 16)
                        : Text('${index + 1}'),
                  ),
                  title: Text(
                    step.instruction,
                    style: TextStyle(
                      fontWeight: isCurrentStep ? FontWeight.bold : null,
                      color: isCurrentStep
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                  ),
                  subtitle: Text('${step.durationSeconds}s'),
                  trailing: isCurrentStep && (_isRunning || _isPaused)
                      ? const Icon(Icons.play_circle_filled)
                      : null,
                  onTap: () => _skipToStep(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}



