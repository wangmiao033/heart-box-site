import 'package:flutter/material.dart';

import '../core/theme/app_tokens.dart';
import '../core/theme/mood_accent.dart';
import '../models/mood_kind.dart';

/// 情绪胶囊：图标 + 名称，低饱和点缀。
class MoodPill extends StatelessWidget {
  const MoodPill({
    super.key,
    required this.mood,
    this.compact = false,
  });

  final MoodKind mood;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 5 : 6,
      ),
      decoration: BoxDecoration(
        color: mood.accentSoftSurface(b),
        borderRadius: BorderRadius.circular(AppRadii.chip),
        border: Border.all(
          color: mood.accentColor.withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            mood.icon,
            size: compact ? 16 : 18,
            color: mood.accentColor.withValues(alpha: b == Brightness.light ? 0.95 : 1),
          ),
          SizedBox(width: compact ? 5 : 6),
          Text(
            mood.label,
            style: TextStyle(
              fontSize: compact ? 12 : 13,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
