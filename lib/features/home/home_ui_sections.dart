import 'package:flutter/material.dart';

import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_tokens.dart';
import '../../widgets/app_chip.dart';
import '../../widgets/app_glass_card.dart';
import '../../widgets/app_primary_button.dart';
import '../../widgets/app_text_field.dart';

/// 顶部问候 + 日期 + 温柔副文案。
class HomeGreetingSection extends StatelessWidget {
  const HomeGreetingSection({
    super.key,
    required this.greeting,
    required this.dateLine,
    required this.tagline,
  });

  final String greeting;
  final String dateLine;
  final String tagline;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: AppTypography.pageTitle(tt).copyWith(
            fontSize: 32,
            height: 1.12,
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        Text(
          dateLine,
          style: AppTypography.caption(tt).copyWith(
            fontSize: 14,
            color: scheme.onSurfaceVariant,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: AppSpacing.s12),
        Text(
          tagline,
          style: AppTypography.body(tt).copyWith(
            color: scheme.onSurface.withValues(alpha: 0.82),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

/// 首页主视觉：手记入口。
class HomeComposeHeroCard extends StatelessWidget {
  const HomeComposeHeroCard({
    super.key,
    required this.onWrite,
  });

  final VoidCallback onWrite;

  static const _moods = ['平静', '开心', '低落', '谢谢今天'];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return AppGlassCard(
      variant: AppGlassVariant.elevated,
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.menu_book_rounded,
                color: scheme.primary.withValues(alpha: 0.9),
                size: 26,
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Text(
                  '写下此刻',
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            '不必完整，只要真诚。把今天的情绪，轻轻放进匣子里。',
            style: tt.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSpacing.s20),
          AppTextField(
            hintText: '从这里开始，写一两句也好…',
            readOnly: true,
            onTap: onWrite,
            maxLines: 2,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 8, right: 4),
              child: Icon(
                Icons.edit_outlined,
                color: scheme.onSurfaceVariant.withValues(alpha: 0.65),
                size: 22,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(
            '此刻心情',
            style: tt.labelSmall?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            children: _moods
                .map(
                  (m) => AppChip(
                    label: m,
                    onTap: onWrite,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppSpacing.s20),
          LayoutBuilder(
            builder: (context, c) {
              final w = c.maxWidth.isFinite ? c.maxWidth : 320.0;
              return AppPrimaryButton(
                label: '记一笔',
                icon: Icons.draw_rounded,
                onPressed: onWrite,
                minWidth: w,
              );
            },
          ),
        ],
      ),
    );
  }
}

class HomeQuickActionData {
  const HomeQuickActionData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
}

/// 2～3 个快捷入口玻璃卡。
class HomeQuickActionsRow extends StatelessWidget {
  const HomeQuickActionsRow({super.key, required this.actions});

  final List<HomeQuickActionData> actions;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final wide = c.maxWidth > 520;
        if (wide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < actions.length; i++) ...[
                Expanded(child: _QuickTile(data: actions[i])),
                if (i < actions.length - 1) const SizedBox(width: AppSpacing.s12),
              ],
            ],
          );
        }
        return Column(
          children: [
            for (final a in actions) ...[
              _QuickTile(data: a),
              const SizedBox(height: AppSpacing.s12),
            ],
          ],
        );
      },
    );
  }
}

class _QuickTile extends StatefulWidget {
  const _QuickTile({required this.data});

  final HomeQuickActionData data;

  @override
  State<_QuickTile> createState() => _QuickTileState();
}

class _QuickTileState extends State<_QuickTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final d = widget.data;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AppGlassCard(
        variant: AppGlassVariant.standard,
        onTap: d.onTap,
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  color: scheme.primaryContainer.withValues(
                    alpha: _hover ? 0.65 : 0.45,
                  ),
                ),
                child: Icon(d.icon, color: scheme.primary, size: 22),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.title,
                      style: tt.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      d.subtitle,
                      style: tt.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: scheme.onSurfaceVariant.withValues(alpha: 0.45),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
