import 'package:flutter/material.dart';

/// 配色主题：经典默认 + 四季。
enum AppPalette {
  /// 原版淡紫
  classic,

  seasonWinter,
  seasonSpring,
  seasonSummer,
  seasonAutumn,
}

extension AppPaletteX on AppPalette {
  /// 用于 [SharedPreferences] 等持久化。
  static AppPalette? tryParse(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return AppPalette.values.byName(raw);
    } on ArgumentError {
      return null;
    }
  }

  /// 中文展示名。
  String get labelZh => switch (this) {
        AppPalette.classic => '经典',
        AppPalette.seasonWinter => '冬季',
        AppPalette.seasonSpring => '春季',
        AppPalette.seasonSummer => '夏季',
        AppPalette.seasonAutumn => '秋季',
      };

  /// 生成 Material 3 色板的种子色（浅色 / 深色各用同一种子即可）。
  Color get seedColor => switch (this) {
        /// 参考清爽日程风：明亮蓝主色（四季仍各自种子色）。
        AppPalette.classic => const Color(0xFF2563EB),
        AppPalette.seasonWinter => const Color(0xFF4FC3F7),
        AppPalette.seasonSpring => const Color(0xFF66BB6A),
        AppPalette.seasonSummer => const Color(0xFFFFD54F),
        AppPalette.seasonAutumn => const Color(0xFFFF8A65),
      };

  /// 设置卡片用短文案。
  String get cardBlurb => switch (this) {
        AppPalette.classic => '清冷蓝紫，默认氛围',
        AppPalette.seasonWinter => '冰青与静夜',
        AppPalette.seasonSpring => '新芽与晨风',
        AppPalette.seasonSummer => '暖阳与蝉鸣',
        AppPalette.seasonAutumn => '落叶与晚霞',
      };
}

/// 设置页「四季」列表（不含经典）。
abstract final class AppPaletteGroups {
  static const List<AppPalette> season = [
    AppPalette.seasonWinter,
    AppPalette.seasonSpring,
    AppPalette.seasonSummer,
    AppPalette.seasonAutumn,
  ];
}

/// 季节 / 经典卡片上的渐变与图标（与 [ThemeMode] 无关，仅装饰用）。
abstract final class AppPaletteVisuals {
  static IconData iconOf(AppPalette p) => switch (p) {
        AppPalette.classic => Icons.auto_awesome_rounded,
        AppPalette.seasonWinter => Icons.ac_unit_rounded,
        AppPalette.seasonSpring => Icons.local_florist_rounded,
        AppPalette.seasonSummer => Icons.wb_sunny_rounded,
        AppPalette.seasonAutumn => Icons.park_rounded,
      };

  static Gradient gradientFor(AppPalette p, Brightness brightness) {
    final dark = brightness == Brightness.dark;
    return switch (p) {
      AppPalette.classic => LinearGradient(
          colors: dark
              ? const [Color(0xFF0A2F6B), Color(0xFF1565C0), Color(0xFF42A5F5)]
              : const [Color(0xFFE3F2FD), Color(0xFF64B5F6), Color(0xFF1E88E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      AppPalette.seasonWinter => LinearGradient(
          colors: dark
              ? const [Color(0xFF003D5C), Color(0xFF0277BD), Color(0xFF4DD0E1)]
              : const [Color(0xFFE0F7FF), Color(0xFF4FC3F7), Color(0xFF0288D1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      AppPalette.seasonSpring => LinearGradient(
          colors: dark
              ? const [Color(0xFF0F3D16), Color(0xFF2E7D32), Color(0xFF8BC34A)]
              : const [Color(0xFFE8F8EA), Color(0xFF81C784), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      AppPalette.seasonSummer => LinearGradient(
          colors: dark
              ? const [Color(0xFFE65100), Color(0xFFFFA000), Color(0xFFFFEE58)]
              : const [Color(0xFFFFFDE7), Color(0xFFFFD740), Color(0xFFFFA726)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      AppPalette.seasonAutumn => LinearGradient(
          colors: dark
              ? const [Color(0xFF4E1608), Color(0xFFD84315), Color(0xFFFFAB40)]
              : const [Color(0xFFFFF5E6), Color(0xFFFFAB91), Color(0xFFE64A19)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
    };
  }

  /// 画在渐变上的主色（图标、文字）。
  static Color onGradient(AppPalette p, Brightness brightness) {
    final dark = brightness == Brightness.dark;
    return switch (p) {
      AppPalette.classic => dark ? Colors.white : const Color(0xFF0D47A1),
      AppPalette.seasonWinter => dark ? const Color(0xFFE1F5FE) : const Color(0xFF01579B),
      AppPalette.seasonSpring => dark ? const Color(0xFFC8E6C9) : const Color(0xFF1B5E20),
      AppPalette.seasonSummer => dark ? const Color(0xFFFFF9C4) : const Color(0xFFF57F17),
      AppPalette.seasonAutumn => dark ? const Color(0xFFFFE0B2) : const Color(0xFFBF360C),
    };
  }
}
