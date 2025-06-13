import 'package:flutter/material.dart';

import '../../models/tasting_notes.dart';

class TastingNotesDisplay extends StatelessWidget {
  final TastingNotes tastingNotes;

  const TastingNotesDisplay({Key? key, required this.tastingNotes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTastingGrid(context),
        if (tastingNotes.notes.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Notes',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tastingNotes.notes,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }

  Widget _buildTastingGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildTastingItem(context, 'Sweetness', tastingNotes.sweetness),
        _buildTastingItem(context, 'Acidity', tastingNotes.acidity),
        _buildTastingItem(context, 'Body', tastingNotes.body),
        _buildTastingItem(context, 'Finish', tastingNotes.finish),
      ],
    );
  }

  Widget _buildTastingItem(BuildContext context, String label, double value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: value / 5,
                  backgroundColor: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                value.toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
