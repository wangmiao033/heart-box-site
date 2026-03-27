import 'package:flutter/material.dart';

import '../core/theme/app_tokens.dart';
import 'app_glass_card.dart';

/// 通用卡片：玻璃拟物质感（业务区与 [AppGlassCard] 统一）。
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppInsets.cardPadding),
    this.variant = AppGlassVariant.standard,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final AppGlassVariant variant;

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      padding: padding,
      variant: variant,
      onTap: onTap,
      child: child,
    );
  }
}
