import 'package:flutter/material.dart';

import 'app_colors.dart';

/// 阴影与柔光（浅色 / 深色）。
abstract final class AppShadows {
  static List<BoxShadow> cardLight(BuildContext context) => [
        BoxShadow(
          color: HbColors.cardShadowLight,
          blurRadius: 30,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> cardDark(BuildContext context) => [
        BoxShadow(
          color: HbColors.cardGlowDark,
          blurRadius: 28,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> primaryButtonLight() => [
        BoxShadow(
          color: HbColors.buttonShadowLight,
          blurRadius: 30,
          offset: const Offset(0, 12),
        ),
      ];

  static List<BoxShadow> primaryButtonDark() => [
        BoxShadow(
          color: const Color(0xFF9A8CFF).withValues(alpha: 0.35),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> navFloat(bool light) => [
        BoxShadow(
          color: light
              ? const Color(0xFF60488C).withValues(alpha: 0.10)
              : Colors.white.withValues(alpha: 0.06),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ];
}
