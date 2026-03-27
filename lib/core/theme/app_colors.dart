import 'package:flutter/material.dart';

/// 心事匣语义色（浅色 / 深色基准 + 状态色）。
/// 业务与组件应优先通过 [Theme.of(context).colorScheme] 取色；此处供主题构建与 token 引用。
abstract final class HbColors {
  // —— 浅色 ——
  static const Color lightBgTop = Color(0xFFF7F4FA);
  static const Color lightBgMid = Color(0xFFF5F1F8);
  static const Color lightBgBottom = Color(0xFFF3F0F7);

  static const Color glassLight = Color(0xDCFFFFFF); // ~0.86
  static const Color glassLightSoft = Color(0xB8FFFFFF); // ~0.72

  static const Color brand = Color(0xFF7A6FF0);
  static const Color brandAccent = Color(0xFF8D7CFF);
  static const Color brandSoftLight = Color(0xFFEDE9FF);

  static const Color titleLight = Color(0xFF2F2940);
  static const Color bodyLight = Color(0xFF5A5368);
  static const Color secondaryLight = Color(0xFF8B8498);
  static const Color hintLight = Color(0xFFB6B0C2);

  static const Color borderLight = Color(0x1A7D68AA); // rgba(125,104,170,0.10)

  static const Color cardShadowLight = Color(0x1460488C); // 0 8 30 rgba(96,72,140,0.08)
  static const Color buttonShadowLight = Color(0x337A6FF0); // 0 12 30 brand ~0.20

  // —— 深色 ——
  static const Color darkBgTop = Color(0xFF141321);
  static const Color darkBgMid = Color(0xFF181727);
  static const Color darkBgBottom = Color(0xFF1B192C);

  static const Color glassDark = Color(0x18FFFFFF);
  static const Color glassDarkElevated = Color(0x1AFFFFFF);

  static const Color brandDark = Color(0xFF9A8CFF);
  static const Color brandHighlightDark = Color(0xFFB7ADFF);
  static const Color brandSoftDark = Color(0xFF2A2640);

  static const Color titleDark = Color(0xFFF3EEFF);
  static const Color bodyDark = Color(0xFFD5CFE5);
  static const Color secondaryDark = Color(0xFFA8A1BA);

  static const Color darkTextHint = Color(0xFF8A8398);

  static const Color borderDark = Color(0x14FFFFFF);

  static const Color cardGlowDark = Color(0x289A8CFF);

  // —— 状态 ——
  static const Color success = Color(0xFF6BBF8A);
  static const Color warning = Color(0xFFF2B866);
  static const Color errorState = Color(0xFFE17D7D);
  static const Color info = Color(0xFF73A8F5);

  // —— 情绪点缀（与旧版兼容）——
  static const Color moodCalm = Color(0xFF8EA6D9);
  static const Color moodHappy = Color(0xFFE6C87A);
  static const Color moodGrateful = Color(0xFFC9B4D4);
  static const Color moodLow = Color(0xFFB6A4D8);
  static const Color moodAnxious = Color(0xFFD9A08E);
  static const Color moodAngry = Color(0xFFD98B8B);
}
