import 'package:flutter/material.dart';

import '../models/mood_kind.dart';

class MoodPicker extends StatelessWidget {
  const MoodPicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final MoodKind value;
  final ValueChanged<MoodKind> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: MoodKind.values.map((m) {
        final selected = m == value;
        return FilterChip(
          avatar: Icon(
            m.icon,
            size: 20,
            color: selected ? scheme.onSecondaryContainer : scheme.onSurfaceVariant,
          ),
          label: Text(m.label),
          selected: selected,
          onSelected: (_) => onChanged(m),
          showCheckmark: false,
        );
      }).toList(),
    );
  }
}
