import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';

export 'app_radius.dart';
export 'app_spacing.dart';
export 'app_colors.dart';
export 'app_shadows.dart';
export 'app_text_styles.dart';

/// 兼容旧命名的颜色访问（逐步迁移到 [HbColors] / ColorScheme）。
abstract final class AppColors {
  static const Color pageBackground = HbColors.lightBgTop;
  static const Color card = Color(0xFFFFFFFF);
  static const Color surfaceSoft = HbColors.lightBgMid;
  static const Color surfaceZone = HbColors.lightBgBottom;
  static const Color border = Color(0x337D68AA);

  static const Color textPrimary = HbColors.titleLight;
  static const Color textSecondary = HbColors.secondaryLight;
  static const Color textHint = HbColors.hintLight;

  static const Color brand = HbColors.brand;
  static const Color brandSoft = HbColors.brandSoftLight;
  static const Color brandPressed = Color(0xFF6B5FDB);

  static const Color moodCalm = HbColors.moodCalm;
  static const Color moodHappy = HbColors.moodHappy;
  static const Color moodGrateful = HbColors.moodGrateful;
  static const Color moodLow = HbColors.moodLow;
  static const Color moodAnxious = HbColors.moodAnxious;
  static const Color moodAngry = HbColors.moodAngry;

  static const Color darkPage = HbColors.darkBgTop;
  static const Color darkCard = HbColors.darkBgMid;
  static const Color darkSurfaceSoft = HbColors.darkBgBottom;
  static const Color darkBorder = HbColors.borderDark;
  static const Color darkTextPrimary = HbColors.titleDark;
  static const Color darkTextSecondary = HbColors.secondaryDark;
  static const Color darkTextHint = Color(0xFF8A8398);
}

abstract final class AppRadii {
  static const double cardLarge = AppRadius.lg;
  static const double card = AppRadius.md;
  static const double pill = AppRadius.xl;
  static const double chip = AppRadius.xs;
}

abstract final class AppInsets {
  static const double pageH = AppSpacing.s20;
  static const double pageV = AppSpacing.s8;
  static const double cardPadding = AppSpacing.s16;
  static const double sectionGap = AppSpacing.s12;
}

abstract final class AppLayout {
  static const double maxContentWidth = 820;

  static const double shellTabBottomPadding = 100;

  static const double shellHomeBottomPadding = 108;

  static double sideInset(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w > maxContentWidth ? (w - maxContentWidth) / 2 : 0;
  }
}

/// 排版令牌（颜色继承自 [ThemeData.textTheme]，请保证 [AppTheme] 已写入 semantic）。
abstract final class AppTypography {
  static TextStyle pageTitle(TextTheme t) =>
      (t.headlineMedium ?? const TextStyle()).copyWith(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.5,
      );

  static TextStyle sectionTitle(TextTheme t) =>
      (t.titleMedium ?? const TextStyle()).copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.25,
      );

  static TextStyle cardTitle(TextTheme t) =>
      (t.titleSmall ?? const TextStyle()).copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle body(TextTheme t) =>
      (t.bodyMedium ?? const TextStyle()).copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle bodyMediumEmphasis(TextTheme t) =>
      body(t).copyWith(fontWeight: FontWeight.w500);

  static TextStyle caption(TextTheme t) =>
      (t.bodySmall ?? const TextStyle()).copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  static TextStyle micro(TextTheme t) =>
      caption(t).copyWith(fontSize: 11);
}
