import 'package:flutter/material.dart';

import 'app_colors.dart';

/// 统一排版层级（与 [ThemeData.textTheme] 协同）。
abstract final class AppTextStyles {
  static TextStyle displayHero(TextTheme t, {required Color color}) =>
      (t.headlineLarge ?? const TextStyle()).copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.15,
        letterSpacing: -0.8,
        color: color,
      );

  static TextStyle h1(TextTheme t, {required Color color}) =>
      (t.headlineMedium ?? const TextStyle()).copyWith(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.5,
        color: color,
      );

  static TextStyle h2(TextTheme t, {required Color color}) =>
      (t.titleLarge ?? const TextStyle()).copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: color,
      );

  static TextStyle h3(TextTheme t, {required Color color}) =>
      (t.titleMedium ?? const TextStyle()).copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: color,
      );

  static TextStyle title(TextTheme t, {required Color color}) =>
      (t.titleSmall ?? const TextStyle()).copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: color,
      );

  static TextStyle body(TextTheme t, {required Color color}) =>
      (t.bodyLarge ?? const TextStyle()).copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color,
      );

  static TextStyle bodySmall(TextTheme t, {required Color color}) =>
      (t.bodySmall ?? const TextStyle()).copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: color,
      );

  static TextStyle label(TextTheme t, {required Color color}) =>
      (t.labelLarge ?? const TextStyle()).copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: color,
      );

  static TextStyle caption(TextTheme t, {required Color color}) =>
      (t.labelSmall ?? const TextStyle()).copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: color,
      );

  /// 浅色页上默认主色字
  static Color titleOnLight(ColorScheme scheme) => HbColors.titleLight;

  static Color bodyOnLight(ColorScheme scheme) => HbColors.bodyLight;

  static Color titleOnDark(ColorScheme scheme) => HbColors.titleDark;

  static Color bodyOnDark(ColorScheme scheme) => HbColors.bodyDark;
}
