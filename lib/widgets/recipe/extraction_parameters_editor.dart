import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_provider.dart';
import '../../models/extraction_parameters.dart';
class ExtractionParametersEditor extends StatefulWidget {
  final ExtractionParameters parameters;
  final ValueChanged<ExtractionParameters> onChanged;

  const ExtractionParametersEditor({
    Key? key,
    required this.parameters,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<ExtractionParametersEditor> createState() => _ExtractionParametersEditorState();
}

class _ExtractionParametersEditorState extends State<ExtractionParametersEditor> {
  late TextEditingController _coffeeController;
  late TextEditingController _waterController;
  late TextEditingController _temperatureController;
  late TextEditingController _timeController;

  @override
  void initState() {
    super.initState();
    _coffeeController = TextEditingController(
      text: widget.parameters.coffeeAmount.toString(),
    );
    _waterController = TextEditingController(
      text: widget.parameters.waterAmount.toString(),
    );
    _temperatureController = TextEditingController(
      text: widget.parameters.temperature.toString(),
    );
    _timeController = TextEditingController(
      text: widget.parameters.totalTimeSeconds.toString(),
    );
  }

  @override
  void dispose() {
    _coffeeController.dispose();
    _waterController.dispose();
    _temperatureController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _coffeeController,
                    decoration: const InputDecoration(
                      labelText: 'Coffee (g)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: _updateParameters,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _waterController,
                    decoration: const InputDecoration(
                      labelText: 'Water (ml)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: _updateParameters,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _temperatureController,
                    decoration: InputDecoration(
                      labelText: 'Temperature (${settingsProvider.isCelsius ? '°C' : '°F'})',
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: _updateParameters,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _timeController,
                    decoration: const InputDecoration(
                      labelText: 'Time (seconds)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: _updateParameters,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'Ratio: ${widget.parameters.ratio.toStringAsFixed(1)}:1',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.parameters.waterAmount.toStringAsFixed(0)}ml water : ${widget.parameters.coffeeAmount.toStringAsFixed(0)}g coffee',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _updateParameters([String? value]) {
    final coffeeAmount = double.tryParse(_coffeeController.text) ?? widget.parameters.coffeeAmount;
    final waterAmount = double.tryParse(_waterController.text) ?? widget.parameters.waterAmount;
    final temperature = double.tryParse(_temperatureController.text) ?? widget.parameters.temperature;
    final totalTimeSeconds = int.tryParse(_timeController.text) ?? widget.parameters.totalTimeSeconds;

    final updatedParameters = ExtractionParameters(
      coffeeAmount: coffeeAmount,
      waterAmount: waterAmount,
      temperature: temperature,
      totalTimeSeconds: totalTimeSeconds,
      isCelsius: widget.parameters.isCelsius,
    );

    widget.onChanged(updatedParameters);
  }
}

