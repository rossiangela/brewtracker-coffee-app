import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../providers/recipe_provider.dart';
import '../../widgets/recipe/recipe_card.dart';
import '../../widgets/recipe/recipe_filter_bar.dart';
class RecipesScreen extends StatelessWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        actions: [
          IconButton(
            onPressed: () => context.go('/add-recipe'),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          const RecipeFilterBar(),
          Expanded(
            child: Consumer<RecipeProvider>(
              builder: (context, recipeProvider, child) {
                if (recipeProvider.recipes.isEmpty) {
                  return _buildEmptyState(context);
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: recipeProvider.recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipeProvider.recipes[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: RecipeCard(recipe: recipe),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No recipes found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first recipe or adjust your filters',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.go('/add-recipe'),
            icon: const Icon(Icons.add),
            label: const Text('Add Recipe'),
          ),
        ],
      ),
    );
  }
}
