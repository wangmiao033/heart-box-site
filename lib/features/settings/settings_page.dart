import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import '../../core/prefs/app_prefs.dart';
import '../../core/security/lock_session.dart';
import '../../core/security/pin_store.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _bioAvailable = false;
  final _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkBio());
  }

  Future<void> _checkBio() async {
    final can = await _localAuth.canCheckBiometrics;
    final supported = await _localAuth.isDeviceSupported();
    if (mounted) {
      setState(() => _bioAvailable = can && supported);
    }
  }

  Future<void> _setPinFlow() async {
    final pin1 = await _askPin(context, title: '设置数字密码');
    if (!mounted) return;
    if (pin1 == null || pin1.length < 4) return;
    final pin2 = await _askPin(context, title: '再次输入以确认');
    if (!mounted) return;
    if (pin2 != pin1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('两次输入不一致')),
      );
      return;
    }
    final pinStore = context.read<PinStore>();
    await pinStore.setPin(pin1);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('密码已保存')),
    );
  }

  Future<void> _changePinFlow() async {
    final old = await _askPin(context, title: '输入当前密码');
    if (!mounted) return;
    if (old == null) return;
    final pinStore = context.read<PinStore>();
    final ok = await pinStore.verify(old);
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('当前密码不正确')),
      );
      return;
    }
    await _setPinFlow();
  }

  Future<String?> _askPin(
    BuildContext context, {
    required String title,
  }) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLength: 8,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            hintText: '4–8 位数字',
            counterText: '',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('确定'),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<AppPrefs>();
    final lock = context.read<LockSession>();
    final pinStore = context.read<PinStore>();

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          const ListTile(
            title: Text('外观'),
            subtitle: Text('主题'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: SegmentedButton<ThemeMode>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.system,
                  label: Text('系统'),
                  icon: Icon(Icons.brightness_auto, size: 18),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.light,
                  label: Text('浅色'),
                  icon: Icon(Icons.light_mode_outlined, size: 18),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.dark,
                  label: Text('深色'),
                  icon: Icon(Icons.dark_mode_outlined, size: 18),
                ),
              ],
              selected: {prefs.themeMode},
              onSelectionChanged: (next) {
                if (next.isEmpty) return;
                prefs.setThemeMode(next.first);
              },
            ),
          ),
          const Divider(height: 32),
          const ListTile(
            title: Text('隐私与安全'),
            subtitle: Text('应用锁与生物识别'),
          ),
          SwitchListTile(
            title: const Text('进入应用需要解锁'),
            subtitle: const Text('需先设置数字密码'),
            value: prefs.lockEnabled,
            onChanged: (v) async {
              if (v) {
                final has = await pinStore.hasPin;
                if (!mounted) return;
                if (!has) {
                  await _setPinFlow();
                  if (!mounted) return;
                  final nowHas = await pinStore.hasPin;
                  if (!mounted) return;
                  if (!nowHas) return;
                }
                await prefs.setLockEnabled(true);
                if (!mounted) return;
                lock.unlock();
              } else {
                await prefs.setLockEnabled(false);
                await prefs.setBiometricEnabled(false);
                if (!mounted) return;
                lock.onLockDisabled();
              }
            },
          ),
          FutureBuilder<bool>(
            future: pinStore.hasPin,
            builder: (context, snap) {
              final has = snap.data ?? false;
              return ListTile(
                title: const Text('修改数字密码'),
                enabled: has,
                trailing: const Icon(Icons.chevron_right),
                onTap: has ? _changePinFlow : null,
              );
            },
          ),
          SwitchListTile(
            title: const Text('使用生物识别解锁'),
            subtitle: Text(
              _bioAvailable ? '指纹或面容（若设备支持）' : '当前设备不可用',
            ),
            value: prefs.biometricEnabled,
            onChanged: (!_bioAvailable || !prefs.lockEnabled)
                ? null
                : (v) => prefs.setBiometricEnabled(v),
          ),
          SwitchListTile(
            title: const Text('从后台回到前台时重新锁定'),
            value: prefs.lockOnResume,
            onChanged: prefs.lockEnabled
                ? (v) => prefs.setLockOnResume(v)
                : null,
          ),
          const Divider(height: 32),
          const ListTile(
            title: Text('关于'),
            subtitle: Text('心事匣 MVP · 数据仅存本机'),
          ),
        ],
      ),
    );
  }
}
