import 'package:flutter/material.dart';

import '../core/theme/app_spacing.dart';
import '../core/theme/app_tokens.dart';

enum AppSectionTone { standard, hero }

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.tone = AppSectionTone.standard,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final AppSectionTone tone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final titleStyle = tone == AppSectionTone.hero
        ? AppTypography.pageTitle(tt).copyWith(
            fontSize: 26,
            color: scheme.onSurface,
          )
        : AppTypography.sectionTitle(tt).copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
          );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: titleStyle),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    subtitle!,
                    style: AppTypography.caption(tt).copyWith(
                      color: scheme.onSurfaceVariant,
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
