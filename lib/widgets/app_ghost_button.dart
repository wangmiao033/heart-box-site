import 'package:flutter/material.dart';

import '../core/theme/app_radius.dart';
import '../core/theme/app_spacing.dart';

/// 幽灵按钮：文字为主，悬停极淡底。
class AppGhostButton extends StatefulWidget {
  const AppGhostButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  State<AppGhostButton> createState() => _AppGhostButtonState();
}

class _AppGhostButtonState extends State<AppGhostButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final style = TextButton.styleFrom(
      foregroundColor: scheme.primary,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      backgroundColor: _hover ? scheme.primary.withValues(alpha: 0.06) : null,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: widget.icon == null
          ? TextButton(
              onPressed: widget.onPressed,
              style: style,
              child: Text(widget.label),
            )
          : TextButton.icon(
              onPressed: widget.onPressed,
              style: style,
              icon: Icon(widget.icon, size: 18, color: scheme.primary),
              label: Text(widget.label),
            ),
    );
  }
}
