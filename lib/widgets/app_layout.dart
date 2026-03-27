import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme/app_tokens.dart';

/// Web / 桌面下将内容限制在 [AppLayout.maxContentWidth] 内并水平居中。
///
/// 必须同时给出 **minWidth == maxWidth == min(视口宽, maxContentWidth)**：
/// 仅设 maxWidth 时，[IndexedStack] / [Scaffold] 等子树在弱约束父级下可能出现
/// **横向最小宽度为 0**，Web 上表现为整页主体「全黑」只剩底栏（底栏在外层 Scaffold 上）。
///
/// 在父级高度有限时同步拉满竖直方向，避免壳子高度不稳定。
class AppContentWidth extends StatelessWidget {
  const AppContentWidth({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final maxH = constraints.maxHeight;

        final BoxConstraints boxConstraints;
        if (maxW.isFinite) {
          final colW = math.min(maxW, AppLayout.maxContentWidth);
          if (maxH.isFinite) {
            boxConstraints = BoxConstraints(
              minWidth: colW,
              maxWidth: colW,
              minHeight: maxH,
              maxHeight: maxH,
            );
          } else {
            boxConstraints = BoxConstraints(
              minWidth: colW,
              maxWidth: colW,
            );
          }
        } else {
          boxConstraints = maxH.isFinite
              ? BoxConstraints(
                  maxWidth: AppLayout.maxContentWidth,
                  minHeight: maxH,
                  maxHeight: maxH,
                )
              : const BoxConstraints(maxWidth: AppLayout.maxContentWidth);
        }

        return Center(
          child: ConstrainedBox(
            constraints: boxConstraints,
            child: child,
          ),
        );
      },
    );
  }
}
