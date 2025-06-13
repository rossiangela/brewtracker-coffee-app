import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recipe_provider.dart';
import '../../models/enums/brew_method.dart';
class RecipeFilterBar extends StatefulWidget {
  const RecipeFilterBar({Key? key}) : super(key: key);

  @override
  State<RecipeFilterBar> createState() => _RecipeFilterBarState();
}

class _RecipeFilterBarState extends State<RecipeFilterBar> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeProvider>(
      builder: (context, recipeProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search recipes...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            recipeProvider.searchRecipes('');
                          },
                        )
                      : null,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) {
                  recipeProvider.searchRecipes(value);
                },
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All Methods'),
                      selected: recipeProvider.filterBrewMethod == null,
                      onSelected: (selected) {
                        if (selected) {
                          recipeProvider.filterByBrewMethod(null);
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    ...BrewMethod.values.map((brewMethod) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(_getBrewMethodString(brewMethod)),
                          selected: recipeProvider.filterBrewMethod == brewMethod,
                          onSelected: (selected) {
                            recipeProvider.filterByBrewMethod(
                              selected ? brewMethod : null,
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
              if (recipeProvider.searchQuery.isNotEmpty ||
                  recipeProvider.filterBrewMethod != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Filters active',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        _searchController.clear();
                        recipeProvider.clearFilters();
                      },
                      child: const Text('Clear All'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
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
}
