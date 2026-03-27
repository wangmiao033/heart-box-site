import 'package:flutter/material.dart';

import '../core/theme/app_tokens.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onSubmitted,
    this.hintText = '搜索心事、关键词或标签',
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final light = Theme.of(context).brightness == Brightness.light;

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        return Container(
          height: 46,
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withValues(alpha: light ? 1 : 0.85),
            borderRadius: BorderRadius.circular(AppRadii.pill),
            border: Border.all(
              color: scheme.outline.withValues(alpha: light ? 0.35 : 0.4),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Icon(
                Icons.search_rounded,
                size: 22,
                color: scheme.onSurfaceVariant.withValues(alpha: 0.75),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  style: AppTypography.body(Theme.of(context).textTheme).copyWith(
                        color: scheme.onSurface,
                      ),
                  cursorColor: scheme.primary,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: AppTypography.body(Theme.of(context).textTheme).copyWith(
                          color: scheme.onSurfaceVariant.withValues(alpha: 0.65),
                        ),
                  ),
                ),
              ),
              if (value.text.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.close_rounded, size: 20, color: scheme.onSurfaceVariant),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
        );
      },
    );
  }
}
