import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_provider.dart';
import '../../models/enums/rating_type.dart';

class RatingDisplay extends StatelessWidget {
  final double rating;
  final bool compact;

  const RatingDisplay({
    Key? key,
    required this.rating,
    this.compact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        switch (settingsProvider.ratingType) {
          case RatingType.stars:
            return _buildStarRating(context);
          case RatingType.score:
            return _buildScoreRating(context);
          case RatingType.emoji:
            return _buildEmojiRating(context);
        }
      },
    );
  }

  Widget _buildStarRating(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          final starRating = index + 1;
          return Icon(
            rating >= starRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: compact ? 16 : 20,
          );
        }),
        if (!compact) ...[
          const SizedBox(width: 8),
          Text(
            rating.toStringAsFixed(1),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }

  Widget _buildScoreRating(BuildContext context) {
    final score = (rating * 20).round(); // Convert 0-5 to 0-100
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$score',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          '/100',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildEmojiRating(BuildContext context) {
    String emoji;
    if (rating <= 2) {
      emoji = '😞';
    } else if (rating <= 3.5) {
      emoji = '😐';
    } else {
      emoji = '😊';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          emoji,
          style: TextStyle(fontSize: compact ? 16 : 24),
        ),
        if (!compact) ...[
          const SizedBox(width: 8),
          Text(
            rating.toStringAsFixed(1),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }
}