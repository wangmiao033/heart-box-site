import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'auth_controller.dart';
import 'auth_validation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final auth = context.read<AuthController>();
    if (!auth.isCloudAuthAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('云端账号未配置，请使用 dart-define 传入 SUPABASE_URL 与 SUPABASE_ANON_KEY'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final email = _email.text.trim();
    final password = _password.text;
    if (!isWellFormedEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入有效邮箱'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final pwErr = validateAccountPassword(password);
    if (pwErr != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(pwErr), behavior: SnackBarBehavior.floating),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await auth.signInWithEmail(email: email, password: password);
      if (!mounted) return;
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/settings');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(formatAuthError(e)),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('登录')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            '使用邮箱登录云端账号',
            style: tt.titleMedium?.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: 8),
          Text(
            '登录后可在此 App 内使用后续云同步（下一阶段开放）。',
            style: tt.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: '邮箱',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _password,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: '密码',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _loading ? null : _submit,
            child: _loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('登录'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: _loading ? null : () => context.push('/register'),
            child: const Text('没有账号？去注册'),
          ),
        ],
      ),
    );
  }
}
