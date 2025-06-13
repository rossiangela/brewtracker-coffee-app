import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../providers/coffee_provider.dart';
import '../../widgets/coffee/coffee_card.dart';
import '../../widgets/common/search_filter_bar.dart';
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee Catalog'),
        actions: [
          IconButton(
            onPressed: () => context.go('/add-coffee'),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          const SearchFilterBar(),
          Expanded(
            child: Consumer<CoffeeProvider>(
              builder: (context, coffeeProvider, child) {
                if (coffeeProvider.coffees.isEmpty) {
                  return _buildEmptyState(context);
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: coffeeProvider.coffees.length,
                  itemBuilder: (context, index) {
                    final coffee = coffeeProvider.coffees[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CoffeeCard(coffee: coffee),
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
            Icons.coffee_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No coffees found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first coffee or adjust your filters',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.go('/add-coffee'),
            icon: const Icon(Icons.add),
            label: const Text('Add Coffee'),
          ),
        ],
      ),
    );
  }
}
