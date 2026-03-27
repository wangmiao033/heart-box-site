import 'package:flutter/material.dart';

import '../../models/mood_kind.dart';
import 'app_tokens.dart';

/// 情绪局部点缀色（细条、图标底、胶囊），不用于整卡背景。
extension MoodKindAccent on MoodKind {
  Color get accentColor => switch (this) {
        MoodKind.calm => AppColors.moodCalm,
        MoodKind.happy => AppColors.moodHappy,
        MoodKind.grateful => AppColors.moodGrateful,
        MoodKind.low => AppColors.moodLow,
        MoodKind.anxious => AppColors.moodAnxious,
        MoodKind.angry => AppColors.moodAngry,
      };

  /// 极浅情绪 tint，用于图标圆角底。
  Color accentSoftSurface(Brightness b) {
    final base = accentColor;
    return b == Brightness.light
        ? Color.alphaBlend(base.withValues(alpha: 0.14), AppColors.card)
        : Color.alphaBlend(base.withValues(alpha: 0.22), AppColors.darkCard);
  }
}
