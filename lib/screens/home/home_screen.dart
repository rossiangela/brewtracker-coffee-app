import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../providers/coffee_provider.dart';
import '../../providers/recipe_provider.dart';
import '../../widgets/coffee/coffee_card.dart';
import '../../widgets/recipe/recipe_card.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/logo.jpeg',
              height: 32,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.coffee, size: 32);
              },
            ),
            const SizedBox(width: 8),
            const Text('Brew Tracker'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(context),
            const SizedBox(height: 24),
            _buildQuickStats(context),
            const SizedBox(height: 24),
            _buildRecentCoffees(context),
            const SizedBox(height: 24),
            _buildFavoriteRecipes(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to BrewLog',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Track your coffee journey, discover new flavors, and perfect your brewing techniques.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Consumer2<CoffeeProvider, RecipeProvider>(
      builder: (context, coffeeProvider, recipeProvider, child) {
        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'Coffees',
                coffeeProvider.coffees.length.toString(),
                Icons.coffee,
                () => context.go('/catalog'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                'Recipes',
                recipeProvider.recipes.length.toString(),
                Icons.receipt_long,
                () => context.go('/recipes'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                'Avg Rating',
                _calculateAverageRating(coffeeProvider.coffees),
                Icons.star,
                null,
              ),
            ),
          ],
        );
      },
    );
  }

  String _calculateAverageRating(List coffees) {
    if (coffees.isEmpty) return '0.0';
    final average = coffees.map((c) => c.rating).reduce((a, b) => a + b) / coffees.length;
    return average.toStringAsFixed(1);
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, VoidCallback? onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentCoffees(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Coffees',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.go('/catalog'),
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Consumer<CoffeeProvider>(
          builder: (context, coffeeProvider, child) {
            final recentCoffees = coffeeProvider.coffees.take(3).toList();
            
            if (recentCoffees.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.coffee_outlined,
                        size: 48,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No coffees yet',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Add your first coffee to get started',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => context.go('/add-coffee'),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Coffee'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: recentCoffees
                  .map((coffee) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: CoffeeCard(coffee: coffee),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFavoriteRecipes(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Popular Recipes',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.go('/recipes'),
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Consumer<RecipeProvider>(
          builder: (context, recipeProvider, child) {
            final popularRecipes = recipeProvider.recipes.take(2).toList();
            
            if (popularRecipes.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 48,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No recipes yet',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Create your first recipe to get started',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => context.go('/add-recipe'),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Recipe'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: popularRecipes
                  .map((recipe) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: RecipeCard(recipe: recipe),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

