import 'package:flutter/material.dart';

import '../core/theme/app_tokens.dart';

/// 全屏子路由用：限制最大宽度 + 水平内边距（与壳层 [AppLayout.maxContentWidth] 一致）。
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppLayout.maxContentWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppInsets.pageH),
              child: body,
            ),
          ),
        ),
      ),
    );
  }
}
