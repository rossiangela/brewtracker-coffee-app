import 'package:flutter/material.dart';

import '../../models/tasting_notes.dart';

class TastingNotesEditor extends StatefulWidget {
  final TastingNotes tastingNotes;
  final ValueChanged<TastingNotes> onChanged;

  const TastingNotesEditor({
    Key? key,
    required this.tastingNotes,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<TastingNotesEditor> createState() => _TastingNotesEditorState();
}

class _TastingNotesEditorState extends State<TastingNotesEditor> {
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.tastingNotes.notes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSliderSection(
          'Sweetness',
          widget.tastingNotes.sweetness,
          (value) => _updateTastingNotes(sweetness: value),
        ),
        const SizedBox(height: 16),
        _buildSliderSection(
          'Acidity',
          widget.tastingNotes.acidity,
          (value) => _updateTastingNotes(acidity: value),
        ),
        const SizedBox(height: 16),
        _buildSliderSection(
          'Body',
          widget.tastingNotes.body,
          (value) => _updateTastingNotes(body: value),
        ),
        const SizedBox(height: 16),
        _buildSliderSection(
          'Finish',
          widget.tastingNotes.finish,
          (value) => _updateTastingNotes(finish: value),
        ),
        const SizedBox(height: 24),
        Text(
          'Additional Notes',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Describe the flavor profile, aroma, and overall experience...',
          ),
          maxLines: 4,
          onChanged: (value) => _updateTastingNotes(notes: value),
        ),
      ],
    );
  }

  Widget _buildSliderSection(String label, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              value.toStringAsFixed(1),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: 5,
          divisions: 50,
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _updateTastingNotes({
    double? sweetness,
    double? acidity,
    double? body,
    double? finish,
    String? notes,
  }) {
    final updatedNotes = TastingNotes(
      sweetness: sweetness ?? widget.tastingNotes.sweetness,
      acidity: acidity ?? widget.tastingNotes.acidity,
      body: body ?? widget.tastingNotes.body,
      finish: finish ?? widget.tastingNotes.finish,
      notes: notes ?? widget.tastingNotes.notes,
    );
    widget.onChanged(updatedNotes);
  }
}

