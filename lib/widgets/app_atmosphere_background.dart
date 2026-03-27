import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// 全页柔雾渐变 + 微光晕（浅色：晨雾；深色：夜灯）。
class AppAtmosphereBackground extends StatelessWidget {
  const AppAtmosphereBackground({super.key, required this.brightness});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final light = brightness == Brightness.light;

    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: light
                    ? const [
                        HbColors.lightBgTop,
                        HbColors.lightBgMid,
                        HbColors.lightBgBottom,
                      ]
                    : const [
                        HbColors.darkBgTop,
                        HbColors.darkBgMid,
                        HbColors.darkBgBottom,
                      ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),
          // 右上柔紫光晕
          Positioned(
            top: -80,
            right: -60,
            child: _glowBlob(
              light
                  ? HbColors.brand.withValues(alpha: 0.14)
                  : HbColors.brandDark.withValues(alpha: 0.12),
              220,
            ),
          ),
          // 左下暖雾
          Positioned(
            bottom: -100,
            left: -80,
            child: _glowBlob(
              light
                  ? const Color(0xFFE8DDF5).withValues(alpha: 0.55)
                  : HbColors.brandDark.withValues(alpha: 0.06),
              280,
            ),
          ),
          if (!light)
            Positioned(
              top: MediaQuery.sizeOf(context).height * 0.35,
              left: 0,
              right: 0,
              child: Center(
                child: _glowBlob(
                  HbColors.brandHighlightDark.withValues(alpha: 0.05),
                  320,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _glowBlob(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
