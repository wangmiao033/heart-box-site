import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_shadows.dart';
import '../core/theme/app_spacing.dart';

class AppFabButton extends StatefulWidget {
  const AppFabButton({
    super.key,
    required this.onPressed,
    this.icon = Icons.edit_note_rounded,
    this.label = '记一笔',
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  @override
  State<AppFabButton> createState() => _AppFabButtonState();
}

class _AppFabButtonState extends State<AppFabButton> {
  bool _hover = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;
    final lift = _hover && !_pressed ? 2.0 : 0.0;
    final scale = _pressed ? 0.96 : 1.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            ..translate(0.0, -lift, 0.0)
            ..scale(scale),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s20,
            vertical: AppSpacing.s12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            gradient: LinearGradient(
              colors: light
                  ? const [HbColors.brand, HbColors.brandAccent]
                  : const [HbColors.brandDark, HbColors.brandHighlightDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              ...(light
                  ? AppShadows.primaryButtonLight()
                  : AppShadows.primaryButtonDark()),
              if (_hover)
                BoxShadow(
                  color: HbColors.brand.withValues(alpha: light ? 0.35 : 0.2),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 22, color: Colors.white),
              const SizedBox(width: AppSpacing.s8),
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
