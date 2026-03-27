import 'package:flutter/material.dart';

/// 设置页用圆润开关（样式由 [AppTheme] 的 [SwitchThemeData] 统一控制）。
class AppToggle extends StatelessWidget {
  const AppToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
    );
  }
}
