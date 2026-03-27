import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/prefs/app_prefs.dart';
import '../core/theme/app_tokens.dart';

/// 左上角本地头像入口；点击进设置。可选 [contentInsetLeft] 与 [AppContentWidth] 内边距对齐。
class LocalAvatarLeading extends StatelessWidget {
  const LocalAvatarLeading({
    super.key,
    this.contentInsetLeft = 0,
  });

  /// 与 [AppLayout.sideInset] + 页内 padding 对齐，例如 `AppLayout.sideInset(context) + 20`。
  final double contentInsetLeft;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Consumer<AppPrefs>(
      builder: (context, prefs, _) {
        final b = prefs.localAvatarJpegBytes;
        return Padding(
          padding: EdgeInsets.only(left: contentInsetLeft),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.go('/settings'),
              customBorder: const CircleBorder(),
              child: SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: scheme.surfaceContainerHighest.withValues(alpha: 0.9),
                    backgroundImage:
                        b != null && b.isNotEmpty ? MemoryImage(b) : null,
                    child: (b == null || b.isEmpty)
                        ? Icon(
                            Icons.person_rounded,
                            size: 22,
                            color: scheme.onSurfaceVariant,
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
