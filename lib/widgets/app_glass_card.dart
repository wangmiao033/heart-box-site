import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_shadows.dart';
import '../core/theme/app_spacing.dart';

enum AppGlassVariant { standard, elevated, subtle }

/// 玻璃质感卡片：半透明、柔边、轻阴影。
class AppGlassCard extends StatefulWidget {
  const AppGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.s20),
    this.variant = AppGlassVariant.standard,
    this.onTap,
    this.borderRadius,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final AppGlassVariant variant;
  final VoidCallback? onTap;
  final double? borderRadius;

  @override
  State<AppGlassCard> createState() => _AppGlassCardState();
}

class _AppGlassCardState extends State<AppGlassCard> {
  bool _hover = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final light = Theme.of(context).brightness == Brightness.light;
    final r = widget.borderRadius ?? AppRadius.lg;

    final baseFill = switch (widget.variant) {
      AppGlassVariant.standard => light ? HbColors.glassLight : HbColors.glassDark,
      AppGlassVariant.elevated =>
        light ? const Color(0xE8FFFFFF) : HbColors.glassDarkElevated,
      AppGlassVariant.subtle =>
        light ? HbColors.glassLightSoft : HbColors.glassDark,
    };

    final borderA = light ? 0.22 : 0.35;
    final shadow = light ? AppShadows.cardLight(context) : AppShadows.cardDark(context);

    final lift = _hover && !_pressed ? 1.0 : 0.0;
    final scale = _pressed ? 0.992 : 1.0;

    final box = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      transform: Matrix4.identity()
        ..translate(0.0, -lift, 0.0)
        ..scale(scale),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(r),
        color: baseFill,
        border: Border.all(
          color: scheme.outline.withValues(
            alpha: borderA + (_hover ? 0.08 : 0),
          ),
        ),
        boxShadow: [
          ...shadow,
          if (_hover)
            BoxShadow(
              color: scheme.primary.withValues(alpha: light ? 0.06 : 0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Padding(padding: widget.padding, child: widget.child),
    );

    Widget core = box;
    if (widget.onTap != null) {
      core = MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onTap,
          child: box,
        ),
      );
    }

    return core;
  }
}
