import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recipe_provider.dart';
import '../../models/recipe.dart';
import '../../models/enums/brew_method.dart';
import '../../widgets/recipe/brew_timer.dart';
class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Recipe? _selectedRecipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brewing Timer'),
      ),
      body: _selectedRecipe == null
          ? _buildRecipeSelection()
          : BrewTimer(
              recipe: _selectedRecipe!,
              onBack: () {
                setState(() {
                  _selectedRecipe = null;
                });
              },
            ),
    );
  }

  Widget _buildRecipeSelection() {
    return Consumer<RecipeProvider>(
      builder: (context, recipeProvider, child) {
        if (recipeProvider.recipes.isEmpty) {
          return _buildEmptyState();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select a Recipe',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...BrewMethod.values.map((method) {
                final recipes = recipeProvider.getRecipesByBrewMethod(method);
                if (recipes.isEmpty) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        _getBrewMethodString(method),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ...recipes.map((recipe) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(recipe.name),
                        subtitle: Text(
                          '${recipe.steps.length} steps • ${_formatDuration(recipe.parameters.totalTimeSeconds)}',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          setState(() {
                            _selectedRecipe = recipe;
                          });
                        },
                      ),
                    )),
                    const SizedBox(height: 16),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No recipes available',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Create a recipe first to use the timer',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  String _getBrewMethodString(BrewMethod method) {
    switch (method) {
      case BrewMethod.espresso:
        return 'Espresso';
      case BrewMethod.pourOver:
        return 'Pour Over';
      case BrewMethod.frenchPress:
        return 'French Press';
      case BrewMethod.aeroPress:
        return 'AeroPress';
      case BrewMethod.coldBrew:
        return 'Cold Brew';
    }
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) {
      return '${seconds}s';
    } else if (seconds < 3600) {
      final minutes = seconds ~/ 60;
      final remainingSeconds = seconds % 60;
      return remainingSeconds > 0 ? '${minutes}m ${remainingSeconds}s' : '${minutes}m';
    } else {
      final hours = seconds ~/ 3600;
      final minutes = (seconds % 3600) ~/ 60;
      return '${hours}h ${minutes}m';
    }
  }
}