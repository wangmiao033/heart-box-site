import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import '../../core/app_meta.dart';
import '../../core/export/journal_export.dart';
import '../../core/prefs/app_prefs.dart';
import '../../data/journal_repository.dart';
import '../../core/profile/local_avatar_codec.dart';
import '../../core/profile/local_avatar_picker.dart';
import '../../core/security/lock_session.dart';
import '../../core/security/pin_store.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_section_header.dart';
import '../../widgets/app_segmented_theme_bar.dart';
import '../../widgets/app_setting_cell.dart';
import '../../widgets/app_theme_preview_card.dart';
import '../../widgets/app_toggle.dart';
import '../auth/auth_controller.dart';
import '../sync/sync_controller.dart';
import '../sync/sync_state.dart';

/// 设置：头像、主题、氛围色、应用锁与关于（无独立 [Scaffold]）。
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static final _pagePadding = EdgeInsets.fromLTRB(
    AppInsets.pageH,
    AppSpacing.s20,
    AppInsets.pageH,
    AppLayout.shellTabBottomPadding,
  );

  final _localAuth = LocalAuthentication();
  bool _bioAvailable = false;
  bool _bioChecked = false;
  bool? _hasPin;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshHasPin();
      if (!kIsWeb) _checkBiometric();
    });
  }

  Future<void> _refreshHasPin() async {
    final h = await context.read<PinStore>().hasPin;
    if (mounted) setState(() => _hasPin = h);
  }

  Future<void> _checkBiometric() async {
    try {
      final supported = await _localAuth.isDeviceSupported();
      final can = await _localAuth.canCheckBiometrics;
      if (mounted) {
        setState(() {
          _bioAvailable = supported && can;
          _bioChecked = true;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _bioChecked = true);
    }
  }

  Future<String?> _askNewPin(String title) async {
    final c1 = TextEditingController();
    final c2 = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: c1,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 8,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: '密码（4–8 位数字）',
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: c2,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 8,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: '再次输入',
                    counterText: '',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () {
                final a = c1.text.trim();
                final b = c2.text.trim();
                if (a.length < 4 || a != b) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('两次输入需一致，且至少 4 位')),
                  );
                  return;
                }
                Navigator.pop(ctx, a);
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
    c1.dispose();
    c2.dispose();
    return result;
  }

  Future<void> _changePin(PinStore pins) async {
    final oldC = TextEditingController();
    final newC = TextEditingController();
    final new2C = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('修改解锁密码'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: oldC,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: '当前密码'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: newC,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 8,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: '新密码（4–8 位）',
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: new2C,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 8,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: '再次输入新密码',
                    counterText: '',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
    if (ok != true || !mounted) {
      oldC.dispose();
      newC.dispose();
      new2C.dispose();
      return;
    }
    final oldP = oldC.text.trim();
    final n1 = newC.text.trim();
    final n2 = new2C.text.trim();
    oldC.dispose();
    newC.dispose();
    new2C.dispose();

    if (n1.length < 4 || n1 != n2) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('新密码需至少 4 位且两次一致')),
        );
      }
      return;
    }
    final valid = await pins.verify(oldP);
    if (!mounted) return;
    if (!valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('当前密码不正确')),
      );
      return;
    }
    await pins.setPin(n1);
    if (mounted) {
      await _refreshHasPin();
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已更新解锁密码')),
    );
  }

  Future<void> _pickAvatar(AppPrefs prefs) async {
    final raw = await pickLocalAvatarImageBytes();
    if (raw == null || !mounted) return;
    final jpeg = encodeLocalAvatarJpeg(raw);
    if (jpeg == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('无法处理该图片，请换一张试试')),
        );
      }
      return;
    }
    await prefs.setLocalAvatarJpegBytes(jpeg);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('头像已更新')),
      );
    }
  }

  Future<void> _onLockToggled(
    AppPrefs prefs,
    LockSession lock,
    PinStore pins,
    bool enable,
  ) async {
    if (enable) {
      final has = await pins.hasPin;
      if (!has) {
        if (!mounted) return;
        final pin = await _askNewPin('开启应用锁');
        if (pin == null || !mounted) return;
        await pins.setPin(pin);
      }
      await prefs.setLockEnabled(true);
    } else {
      await prefs.setLockEnabled(false);
      lock.onLockDisabled();
    }
    if (mounted) await _refreshHasPin();
  }

  Widget _buildAccountCard(BuildContext context, AuthController auth) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    if (!auth.isCloudAuthAvailable) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: AppCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '云端登录未启用。请在构建时通过 --dart-define 传入 SUPABASE_URL 与 SUPABASE_ANON_KEY。',
              style: tt.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
        ),
      );
    }

    if (!auth.isLoggedIn) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: AppCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '未登录',
                  style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  '登录后可将日记正文与标签备份到云端，换设备登录同一账号可恢复。',
                  style: tt.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                FilledButton.tonal(
                  onPressed: () => context.push('/login'),
                  child: const Text('登录'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => context.push('/register'),
                  child: const Text('注册'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final email = auth.currentEmail ?? '（无邮箱）';
    final sync = context.watch<JournalSyncController>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '当前账号',
                style: tt.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 6),
              Text(
                email,
                style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: scheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '已登录',
                    style: tt.bodyMedium?.copyWith(color: scheme.primary),
                  ),
                ],
              ),
              if (sync.showAccountSwitchBanner) ...[
                const SizedBox(height: 12),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: scheme.tertiaryContainer.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '检测到与上次同步使用的账号不同。本地日记均保留；仅当前登录账号的云端数据会参与同步，避免串号。',
                          style: tt.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => sync.dismissAccountSwitchBanner(),
                            child: const Text('知道了'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (sync.isCloudSyncAvailable) ...[
                const SizedBox(height: 14),
                Text(
                  '云端同步（仅文本）',
                  style: tt.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 6),
                Text(
                  _syncStatusLine(sync.uiStatus, sync),
                  style: tt.bodyMedium,
                ),
                if (sync.lastFullSyncAt != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '上次同步：${_formatSyncTime(sync.lastFullSyncAt!)}',
                      style: tt.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                if (sync.lastError != null && sync.uiStatus == JournalSyncUiStatus.failed)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      sync.lastError!,
                      style: tt.bodySmall?.copyWith(color: scheme.error),
                    ),
                  ),
                const SizedBox(height: 12),
                FilledButton.tonal(
                  onPressed: sync.isSyncing
                      ? null
                      : () async {
                          await sync.syncNow();
                        },
                  child: Text(sync.isSyncing ? '同步中…' : '立即同步'),
                ),
              ],
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () async {
                  await auth.signOut();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('已退出登录'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text('退出登录'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _syncStatusLine(JournalSyncUiStatus s, JournalSyncController c) {
    switch (s) {
      case JournalSyncUiStatus.unavailable:
        return '当前无法使用云同步';
      case JournalSyncUiStatus.syncing:
        return '正在与云端同步…';
      case JournalSyncUiStatus.pending:
        return '等待同步（${c.pendingCount} 条待上传）';
      case JournalSyncUiStatus.failed:
        return '同步失败，可点「立即同步」重试';
      case JournalSyncUiStatus.synced:
        return '已同步';
    }
  }

  String _formatSyncTime(DateTime t) {
    final y = t.year.toString().padLeft(4, '0');
    final m = t.month.toString().padLeft(2, '0');
    final d = t.day.toString().padLeft(2, '0');
    final h = t.hour.toString().padLeft(2, '0');
    final min = t.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $h:$min';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final prefs = context.watch<AppPrefs>();
    final lock = context.watch<LockSession>();
    final auth = context.watch<AuthController>();
    final pins = context.read<PinStore>();

    final avatarBytes = prefs.localAvatarJpegBytes;

    return ListView(
      padding: _pagePadding,
      children: [
        AppSectionHeader(
          title: '设置',
          tone: AppSectionTone.hero,
          subtitle: '把这个小空间调整成你喜欢的样子',
        ),
        AppSectionHeader(
          title: '云端账号',
          subtitle: auth.isCloudAuthAvailable
              ? '登录后自动同步日记正文与标签（不含图片）'
              : '未配置 Supabase 时仅使用本地功能',
        ),
        _buildAccountCard(context, auth),
        AppSectionHeader(
          title: '本地头像',
          subtitle: '只留在你的设备里，不会上传到任何地方',
        ),
        AppCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: scheme.primaryContainer.withValues(alpha: 0.65),
                backgroundImage: avatarBytes != null ? MemoryImage(avatarBytes) : null,
                child: avatarBytes == null
                    ? Icon(Icons.person_rounded, size: 36, color: scheme.onPrimaryContainer)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: () => _pickAvatar(prefs),
                      icon: const Icon(Icons.photo_outlined),
                      label: const Text('选择图片'),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: avatarBytes == null
                          ? null
                          : () async {
                              await prefs.clearLocalAvatar();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('已清除头像')),
                                );
                              }
                            },
                      child: const Text('清除头像'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        AppSectionHeader(
          title: '外观',
          subtitle: '浅色、深色，或交给系统替你决定',
        ),
        AppSegmentedThemeBar(
          value: prefs.themeMode,
          onChanged: (m) => prefs.setThemeMode(m),
        ),
        const SizedBox(height: 20),
        AppSectionHeader(
          title: '主题氛围',
          subtitle: '选一种让你安心的色调（与浅色/深色模式独立）',
        ),
        LayoutBuilder(
          builder: (context, c) {
            final cross = c.maxWidth > 540 ? 2 : 1;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cross,
                mainAxisSpacing: AppSpacing.s12,
                crossAxisSpacing: AppSpacing.s12,
                childAspectRatio: cross == 2 ? 0.95 : 1.15,
              ),
              itemCount: AppPalette.values.length,
              itemBuilder: (context, i) {
                final p = AppPalette.values[i];
                return AppThemePreviewCard(
                  palette: p,
                  selected: prefs.appPalette == p,
                  onTap: () => prefs.setAppPalette(p),
                );
              },
            );
          },
        ),
        const SizedBox(height: 8),
        AppSectionHeader(
          title: '隐私与安全',
          subtitle: '给心事匣加一把温柔的小锁',
        ),
        Builder(
          builder: (context) {
            final hasPin = _hasPin ?? false;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppSettingCell(
                  title: '应用锁',
                  subtitle: hasPin ? '已设置数字密码' : '开启前需先设定密码',
                  trailing: AppToggle(
                    value: prefs.lockEnabled,
                    onChanged: (v) async {
                      await _onLockToggled(prefs, lock, pins, v);
                    },
                  ),
                ),
                if (prefs.lockEnabled && hasPin)
                  AppSettingCell(
                    title: '修改解锁密码',
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _changePin(pins),
                  ),
                if (!kIsWeb && (_bioChecked && _bioAvailable))
                  AppSettingCell(
                    title: '使用生物识别解锁',
                    subtitle: '需已开启应用锁',
                    trailing: AppToggle(
                      value: prefs.biometricEnabled,
                      onChanged: prefs.lockEnabled
                          ? (v) => prefs.setBiometricEnabled(v)
                          : null,
                    ),
                  ),
                AppSettingCell(
                  title: '回到前台时锁定',
                  subtitle: '从后台切回时需重新验证',
                  trailing: AppToggle(
                    value: prefs.lockOnResume,
                    onChanged: prefs.lockEnabled
                        ? (v) => prefs.setLockOnResume(v)
                        : null,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        AppSectionHeader(
          title: '数据',
          subtitle: kIsWeb ? '在浏览器里导出一份 JSON，只属于你' : '导出到本机文档目录',
        ),
        AppCard(
          child: AppSettingCell(
            title: '导出全部记录（JSON）',
            subtitle: '含标题、正文、心情、标签与时间，仅保存在本机',
            trailing: const Icon(Icons.file_download_outlined),
            onTap: () async {
              final repo = context.read<JournalRepository>();
              final list = await repo.listAllForExport();
              if (!context.mounted) return;
              await exportAllJournalsToJson(context, list);
            },
          ),
        ),
        const SizedBox(height: 20),
        AppSectionHeader(title: '关于心事匣', subtitle: AppMeta.shortDescription),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '心事匣',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                '版本 ${AppMeta.versionLabel}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                AppMeta.tagline,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
