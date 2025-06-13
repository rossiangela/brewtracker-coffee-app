import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/coffee_provider.dart';
import '../../models/enums/roast_level.dart';
class SearchFilterBar extends StatefulWidget {
  const SearchFilterBar({Key? key}) : super(key: key);

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
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
    return Consumer<CoffeeProvider>(
      builder: (context, coffeeProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search coffees...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            coffeeProvider.searchCoffees('');
                          },
                        )
                      : null,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) {
                  coffeeProvider.searchCoffees(value);
                },
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All Roasts'),
                      selected: coffeeProvider.filterRoastLevel == null,
                      onSelected: (selected) {
                        if (selected) {
                          coffeeProvider.filterByRoastLevel(null);
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    ...RoastLevel.values.map((roastLevel) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(_getRoastLevelString(roastLevel)),
                          selected: coffeeProvider.filterRoastLevel == roastLevel,
                          onSelected: (selected) {
                            coffeeProvider.filterByRoastLevel(
                              selected ? roastLevel : null,
                            );
                          },
                        ),
                      );
                    }),
                    const SizedBox(width: 8),
                    ActionChip(
                      label: const Text('Rating Filter'),
                      avatar: const Icon(Icons.star, size: 16),
                      onPressed: () => _showRatingFilter(context, coffeeProvider),
                    ),
                  ],
                ),
              ),
              if (coffeeProvider.searchQuery.isNotEmpty ||
                  coffeeProvider.filterRoastLevel != null ||
                  coffeeProvider.minRating > 0) ...[
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
                        coffeeProvider.clearFilters();
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

  void _showRatingFilter(BuildContext context, CoffeeProvider coffeeProvider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Minimum Rating',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Rating'),
                        Text(coffeeProvider.minRating.toStringAsFixed(1)),
                      ],
                    ),
                    Slider(
                      value: coffeeProvider.minRating,
                      min: 0,
                      max: 5,
                      divisions: 50,
                      onChanged: (value) {
                        setState(() {
                          coffeeProvider.filterByRating(value);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Apply'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getRoastLevelString(RoastLevel roastLevel) {
    switch (roastLevel) {
      case RoastLevel.light:
        return 'Light';
      case RoastLevel.medium:
        return 'Medium';
      case RoastLevel.mediumDark:
        return 'Medium Dark';
      case RoastLevel.dark:
        return 'Dark';
    }
  }
}