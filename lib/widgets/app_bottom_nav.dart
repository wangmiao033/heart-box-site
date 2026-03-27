import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_shadows.dart';
import '../core/theme/app_spacing.dart';

/// 浮动玻璃底栏：悬停胶囊选中态。
class AppBottomNav extends StatefulWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onSelect,
  });

  final int currentIndex;
  final ValueChanged<int> onSelect;

  @override
  State<AppBottomNav> createState() => _AppBottomNavState();
}

const _kNavItems = <_NavItemData>[
  _NavItemData(Icons.home_outlined, Icons.home_rounded, '首页'),
  _NavItemData(Icons.calendar_month_outlined, Icons.calendar_month_rounded, '日历'),
  _NavItemData(Icons.auto_graph_outlined, Icons.auto_graph_rounded, '回顾'),
  _NavItemData(Icons.settings_outlined, Icons.settings_rounded, '设置'),
];

class _AppBottomNavState extends State<AppBottomNav> {
  int? _hoverIndex;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final light = Theme.of(context).brightness == Brightness.light;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s8,
        AppSpacing.s16,
        AppSpacing.s12 + bottom,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              color: scheme.surfaceContainerLow.withValues(
                alpha: light ? 0.72 : 0.42,
              ),
              border: Border.all(
                color: scheme.outline.withValues(alpha: light ? 0.4 : 0.35),
              ),
              boxShadow: AppShadows.navFloat(light),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s8,
                vertical: AppSpacing.s8,
              ),
              child: Row(
                children: [
                  for (var i = 0; i < _kNavItems.length; i++)
                    Expanded(
                      child: _NavPill(
                        data: _kNavItems[i],
                        selected: i == widget.currentIndex,
                        hovered: _hoverIndex == i,
                        onHover: (v) => setState(() => _hoverIndex = v ? i : null),
                        onTap: () => widget.onSelect(i),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData(this.outlined, this.filled, this.label);
  final IconData outlined;
  final IconData filled;
  final String label;
}

class _NavPill extends StatelessWidget {
  const _NavPill({
    required this.data,
    required this.selected,
    required this.hovered,
    required this.onHover,
    required this.onTap,
  });

  final _NavItemData data;
  final bool selected;
  final bool hovered;
  final void Function(bool) onHover;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final light = Theme.of(context).brightness == Brightness.light;

    final fg = selected
        ? (light ? HbColors.brand : HbColors.brandDark)
        : scheme.onSurfaceVariant;

    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          splashColor: scheme.primary.withValues(alpha: 0.08),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              color: selected
                  ? scheme.primaryContainer.withValues(alpha: light ? 0.85 : 0.5)
                  : hovered
                      ? scheme.primary.withValues(alpha: 0.06)
                      : Colors.transparent,
              border: Border.all(
                color: selected
                    ? scheme.primary.withValues(alpha: 0.35)
                    : Colors.transparent,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selected ? data.filled : data.outlined,
                  size: 22,
                  color: fg,
                ),
                const SizedBox(height: 4),
                Text(
                  data.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: fg,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
