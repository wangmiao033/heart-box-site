import 'package:flutter/material.dart';

import '../core/theme/app_tokens.dart';

/// 系统 / 浅色 / 深色 分段控件（与全局雾紫主题一致）。
class AppSegmentedThemeBar extends StatelessWidget {
  const AppSegmentedThemeBar({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final ThemeMode value;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final light = Theme.of(context).brightness == Brightness.light;

    final shell = light ? AppColors.surfaceSoft : AppColors.darkSurfaceSoft;
    final border = scheme.outline.withValues(alpha: light ? 0.55 : 0.5);
    final selectedBg = light ? AppColors.brandSoft : scheme.primaryContainer.withValues(alpha: 0.55);
    final fg = scheme.onSurface;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: shell,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _seg(
              context,
              selected: value == ThemeMode.system,
              selectedFill: selectedBg,
              borderColor: border,
              foreground: fg,
              onTap: () => onChanged(ThemeMode.system),
              leading: _systemBadge(fg),
              chars: const ['系', '统'],
            ),
          ),
          _vDivider(border),
          Expanded(
            child: _seg(
              context,
              selected: value == ThemeMode.light,
              selectedFill: selectedBg,
              borderColor: border,
              foreground: fg,
              onTap: () => onChanged(ThemeMode.light),
              leading: Icon(Icons.light_mode_outlined, size: 20, color: fg),
              chars: const ['浅', '色'],
            ),
          ),
          _vDivider(border),
          Expanded(
            child: _seg(
              context,
              selected: value == ThemeMode.dark,
              selectedFill: selectedBg,
              borderColor: border,
              foreground: fg,
              onTap: () => onChanged(ThemeMode.dark),
              leading: Icon(Icons.dark_mode_outlined, size: 20, color: fg),
              chars: const ['深', '色'],
            ),
          ),
        ],
      ),
    );
  }

  Widget _systemBadge(Color fg) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: fg, width: 1.2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        'A',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          height: 1,
          color: fg,
        ),
      ),
    );
  }

  Widget _vDivider(Color c) {
    return Container(
      width: 1,
      height: 36,
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: c.withValues(alpha: 0.5),
    );
  }

  Widget _seg(
    BuildContext context, {
    required bool selected,
    required Color selectedFill,
    required Color borderColor,
    required Color foreground,
    required VoidCallback onTap,
    required Widget leading,
    required List<String> chars,
  }) {
    return Material(
      color: selected ? selectedFill : Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: foreground.withValues(alpha: 0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              leading,
              const SizedBox(width: 6),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final c in chars)
                    Text(
                      c,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.05,
                        fontWeight: FontWeight.w600,
                        color: foreground,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
