import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_tokens.dart';

/// 心事匣全局主题：柔雾背景 + 玻璃拟物语义色（浅色 / 深色）。
abstract final class AppTheme {
  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final light = brightness == Brightness.light;

    final scheme = ColorScheme(
      brightness: brightness,
      primary: light ? HbColors.brand : HbColors.brandDark,
      onPrimary: Colors.white,
      primaryContainer:
          light ? HbColors.brandSoftLight : HbColors.brandSoftDark,
      onPrimaryContainer:
          light ? const Color(0xFF2F2859) : HbColors.titleDark,
      secondary: light ? HbColors.brandAccent : HbColors.brandHighlightDark,
      onSecondary: Colors.white,
      tertiary: light ? HbColors.lightBgBottom : HbColors.glassDark,
      onTertiary: light ? HbColors.titleLight : HbColors.titleDark,
      error: HbColors.errorState,
      onError: Colors.white,
      surface: light ? HbColors.lightBgTop : HbColors.darkBgTop,
      onSurface: light ? HbColors.titleLight : HbColors.titleDark,
      onSurfaceVariant:
          light ? HbColors.secondaryLight : HbColors.secondaryDark,
      outline: light ? HbColors.borderLight : HbColors.borderDark,
      outlineVariant: light
          ? const Color(0x227D68AA)
          : const Color(0x10FFFFFF),
      shadow: light
          ? HbColors.cardShadowLight
          : Colors.black.withValues(alpha: 0.35),
      scrim: Colors.black54,
      inverseSurface: light ? HbColors.titleLight : HbColors.lightBgTop,
      onInverseSurface: light ? HbColors.lightBgTop : HbColors.titleLight,
      inversePrimary: HbColors.brandAccent,
      surfaceTint: Colors.transparent,
      surfaceContainerHighest: light
          ? HbColors.lightBgMid
          : HbColors.glassDarkElevated,
      surfaceContainerHigh:
          light ? HbColors.lightBgBottom : HbColors.darkBgMid,
      surfaceContainer: light ? HbColors.glassLightSoft : HbColors.darkBgMid,
      surfaceContainerLow: light ? HbColors.glassLight : HbColors.glassDark,
      surfaceContainerLowest:
          light ? Colors.white : const Color(0xFF12101C),
    );

    final base = ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      brightness: brightness,
    );

    final hintColor = light ? HbColors.hintLight : HbColors.darkTextHint;

    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle:
            light ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
        titleTextStyle: AppTypography.sectionTitle(base.textTheme).copyWith(
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(
            color: scheme.outline.withValues(alpha: light ? 0.35 : 0.5),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(
          alpha: light ? 0.9 : 0.5,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: scheme.outline.withValues(alpha: light ? 0.45 : 0.4),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: scheme.primary.withValues(alpha: 0.85),
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s12,
        ),
        hintStyle: TextStyle(
          color: hintColor,
          fontSize: 14,
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        side: BorderSide(color: scheme.outline.withValues(alpha: 0.35)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        labelStyle: AppTypography.caption(base.textTheme).copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outline.withValues(alpha: 0.35),
        thickness: 1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          }
          return scheme.onSurfaceVariant.withValues(alpha: 0.9);
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return (light ? HbColors.brand : HbColors.brandDark)
                .withValues(alpha: 0.5);
          }
          return scheme.outline.withValues(alpha: 0.35);
        }),
        trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
      ),
      textTheme: base.textTheme.copyWith(
        headlineMedium: AppTypography.pageTitle(base.textTheme).copyWith(
          color: scheme.onSurface,
        ),
        headlineSmall: AppTypography.sectionTitle(base.textTheme).copyWith(
          fontSize: 22,
          color: scheme.onSurface,
        ),
        titleLarge: AppTypography.sectionTitle(base.textTheme).copyWith(
          fontSize: 20,
          color: scheme.onSurface,
        ),
        titleMedium: AppTypography.sectionTitle(base.textTheme).copyWith(
          color: scheme.onSurface,
        ),
        titleSmall: AppTypography.cardTitle(base.textTheme).copyWith(
          color: scheme.onSurface,
        ),
        bodyLarge: AppTypography.body(base.textTheme).copyWith(
          color: scheme.onSurface,
        ),
        bodyMedium: AppTypography.body(base.textTheme).copyWith(
          color: scheme.onSurface,
        ),
        bodySmall: AppTypography.caption(base.textTheme).copyWith(
          color: scheme.onSurfaceVariant,
        ),
        labelLarge: base.textTheme.labelLarge?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
      ),
    );
  }
}
