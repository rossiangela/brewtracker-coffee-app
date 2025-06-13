import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/coffee.dart';
import '../../models/enums/roast_level.dart';
import '../../widgets/common/rating_display.dart';
import '../../utils/image_utils.dart';
class CoffeeCard extends StatelessWidget {
  final Coffee coffee;

  const CoffeeCard({Key? key, required this.coffee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/coffee/${coffee.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: coffee.images.isNotEmpty
                      ? ImageUtils.buildImageWidget(
                          coffee.images.first,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.coffee_outlined, size: 32),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coffee.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      coffee.roaster,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (coffee.origin.isNotEmpty) ...[
                          Expanded(
                            child: Text(
                              coffee.origin,
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getRoastLevelString(coffee.roastLevel),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    RatingDisplay(rating: coffee.rating, compact: true),
                  ],
                ),
              ),
            ],
          ),
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