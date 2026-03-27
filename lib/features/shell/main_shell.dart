import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../widgets/app_atmosphere_background.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/app_fab_button.dart';
import '../../widgets/app_layout.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  Widget? _buildFabGroup(BuildContext context) {
    if (navigationShell.currentIndex != 0) return null;
    return AppFabButton(onPressed: () => context.push('/compose'));
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      // 透明以便透出底层氛围；子页全屏路由仍用主题色兜底。
      body: Stack(
        fit: StackFit.expand,
        children: [
          AppAtmosphereBackground(brightness: brightness),
          SafeArea(
            bottom: false,
            child: SizedBox.expand(
              child: AppContentWidth(
                child: navigationShell,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Align(
        alignment: Alignment.bottomCenter,
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayout.maxContentWidth,
          ),
          child: AppBottomNav(
            currentIndex: navigationShell.currentIndex,
            onSelect: (i) {
              navigationShell.goBranch(
                i,
                initialLocation: i == navigationShell.currentIndex,
              );
            },
          ),
        ),
      ),
      floatingActionButton: _buildFabGroup(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
