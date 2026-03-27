import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_palette.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_shadows.dart';
import '../core/theme/app_spacing.dart';

/// 设置页「主题氛围」预览卡：色块 + 选中发光 + 悬停微浮。
class AppThemePreviewCard extends StatefulWidget {
  const AppThemePreviewCard({
    super.key,
    required this.palette,
    required this.selected,
    required this.onTap,
    this.description,
  });

  final AppPalette palette;
  final bool selected;
  final VoidCallback onTap;
  /// 覆盖 [AppPalette.cardBlurb] 时可传。
  final String? description;

  @override
  State<AppThemePreviewCard> createState() => _AppThemePreviewCardState();
}

class _AppThemePreviewCardState extends State<AppThemePreviewCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final scheme = Theme.of(context).colorScheme;
    final light = brightness == Brightness.light;
    final gradient = AppPaletteVisuals.gradientFor(widget.palette, brightness);
    final desc = widget.description ?? widget.palette.cardBlurb;
    final lift = _hover ? 2.0 : 0.0;

    final previewColors = _previewStripColors(widget.palette, brightness);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..translate(0.0, -lift, 0.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: widget.selected
                  ? scheme.primary
                  : scheme.outline.withValues(alpha: light ? 0.35 : 0.45),
              width: widget.selected ? 2.2 : 1,
            ),
            boxShadow: [
              ...(light ? AppShadows.cardLight(context) : AppShadows.cardDark(context)),
              if (widget.selected)
                BoxShadow(
                  color: scheme.primary.withValues(alpha: light ? 0.18 : 0.25),
                  blurRadius: 18,
                  spreadRadius: 0,
                  offset: const Offset(0, 6),
                ),
            ],
            color: scheme.surfaceContainerLow.withValues(alpha: light ? 0.92 : 0.55),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 72,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    DecoratedBox(decoration: BoxDecoration(gradient: gradient)),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.s12),
                      child: Row(
                        children: [
                          Icon(
                            AppPaletteVisuals.iconOf(widget.palette),
                            color: AppPaletteVisuals.onGradient(
                              widget.palette,
                              brightness,
                            ),
                            size: 26,
                          ),
                          const Spacer(),
                          if (widget.selected)
                            Icon(
                              Icons.check_circle_rounded,
                              color: AppPaletteVisuals.onGradient(
                                widget.palette,
                                brightness,
                              ),
                              size: 22,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.palette.labelZh,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                            height: 1.35,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        for (final c in previewColors) ...[
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: scheme.outline.withValues(alpha: 0.25),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Color> _previewStripColors(AppPalette p, Brightness b) {
    final g = AppPaletteVisuals.gradientFor(p, b);
    if (g is LinearGradient && g.colors.length >= 3) {
      return [
        g.colors.first,
        g.colors[g.colors.length ~/ 2],
        g.colors.last,
      ];
    }
    return const [
      HbColors.brand,
      HbColors.brandAccent,
      HbColors.moodCalm,
    ];
  }
}
