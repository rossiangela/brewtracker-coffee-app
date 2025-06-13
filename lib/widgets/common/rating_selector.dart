import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_provider.dart';
import '../../models/enums/rating_type.dart';
class RatingSelector extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onRatingChanged;

  const RatingSelector({
    Key? key,
    required this.rating,
    required this.onRatingChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        switch (settingsProvider.ratingType) {
          case RatingType.stars:
            return _buildStarSelector(context);
          case RatingType.score:
            return _buildScoreSelector(context);
          case RatingType.emoji:
            return _buildEmojiSelector(context);
        }
      },
    );
  }

  Widget _buildStarSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(5, (index) {
            final starRating = index + 1.0;
            return GestureDetector(
              onTap: () => onRatingChanged(starRating),
              child: Icon(
                rating >= starRating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 32,
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Slider(
          value: rating,
          min: 0,
          max: 5,
          divisions: 50,
          label: rating.toStringAsFixed(1),
          onChanged: onRatingChanged,
        ),
      ],
    );
  }

  Widget _buildScoreSelector(BuildContext context) {
    final score = (rating * 20).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '$score',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              '/100',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: score.toDouble(),
          min: 0,
          max: 100,
          divisions: 100,
          label: score.toString(),
          onChanged: (value) => onRatingChanged(value / 20),
        ),
      ],
    );
  }

  Widget _buildEmojiSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildEmojiOption('😞', 1.5, context),
            _buildEmojiOption('😐', 3.0, context),
            _buildEmojiOption('😊', 4.5, context),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: rating,
          min: 0,
          max: 5,
          divisions: 50,
          label: rating.toStringAsFixed(1),
          onChanged: onRatingChanged,
        ),
      ],
    );
  }

  Widget _buildEmojiOption(String emoji, double value, BuildContext context) {
    final isSelected = (rating - value).abs() < 1.0;
    return GestureDetector(
      onTap: () => onRatingChanged(value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
          ),
        ),
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}