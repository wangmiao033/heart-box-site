import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import '../../core/prefs/app_prefs.dart';
import '../../core/security/lock_session.dart';
import '../../core/security/pin_store.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  String _pin = '';
  String? _error;
  bool _busy = false;
  final _localAuth = LocalAuthentication();

  Future<void> _tryBiometric() async {
    final prefs = context.read<AppPrefs>();
    if (!prefs.biometricEnabled) return;
    final hasPin = await context.read<PinStore>().hasPin;
    if (!hasPin) return;
    final ok = await _localAuth.authenticate(
      localizedReason: '验证身份以解锁心事匣',
      options: const AuthenticationOptions(biometricOnly: true),
    );
    if (ok && mounted) {
      context.read<LockSession>().unlock();
    }
  }

  Future<void> _submitPin() async {
    if (_pin.length < 4) {
      setState(() => _error = '至少输入 4 位数字');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final ok = await context.read<PinStore>().verify(_pin);
    if (!mounted) return;
    if (ok) {
      HapticFeedback.lightImpact();
      context.read<LockSession>().unlock();
    } else {
      setState(() {
        _busy = false;
        _error = '密码不正确';
        _pin = '';
      });
    }
  }

  void _onDigit(int d) {
    if (_busy || _pin.length >= 8) return;
    setState(() {
      _error = null;
      _pin += '$d';
    });
    HapticFeedback.selectionClick();
  }

  void _backspace() {
    if (_busy || _pin.isEmpty) return;
    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryBiometric());
  }

  @override
  Widget build(BuildContext context) {
    final dots = List.generate(8, (i) => i < _pin.length);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Icon(
                Icons.lock_outline_rounded,
                size: 56,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                '心事匣已锁定',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                '输入数字密码解锁',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: dots
                    .map(
                      (f) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          color: f
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                      ),
                    )
                    .toList(),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
              const Spacer(),
              Wrap(
                spacing: 24,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  for (var n = 1; n <= 9; n++)
                    _NumButton(onTap: () => _onDigit(n), label: '$n'),
                  _NumButton(
                    onTap: () async {
                      await _tryBiometric();
                    },
                    icon: Icons.fingerprint_rounded,
                  ),
                  _NumButton(onTap: () => _onDigit(0), label: '0'),
                  _NumButton(
                    onTap: _backspace,
                    icon: Icons.backspace_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _busy ? null : _submitPin,
                child: _busy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('解锁'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NumButton extends StatelessWidget {
  const _NumButton({this.label, this.icon, required this.onTap});

  final String? label;
  final IconData? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 56,
      child: Material(
        type: MaterialType.circle,
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Center(
            child: label != null
                ? Text(label!, style: Theme.of(context).textTheme.titleLarge)
                : Icon(icon),
          ),
        ),
      ),
    );
  }
}
