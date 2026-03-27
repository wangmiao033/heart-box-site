import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'auth_controller.dart';
import 'auth_validation.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
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
    final confirm = _confirm.text;

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
    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('两次输入的密码不一致'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final res = await auth.signUpWithEmail(email: email, password: password);
      if (!mounted) return;

      if (res.session != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('注册成功'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/settings');
        }
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '注册已提交。若项目开启了邮箱验证，请查收邮件完成验证后再登录。',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      if (context.canPop()) context.pop();
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
      appBar: AppBar(title: const Text('注册')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            '注册云端账号',
            style: tt.titleMedium?.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: 8),
          Text(
            '使用邮箱与密码注册；数据仍优先保存在本机，云同步将在后续版本接入。',
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
            decoration: InputDecoration(
              labelText: '密码（至少 $kMinAccountPasswordLength 位）',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _confirm,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: '确认密码',
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
                : const Text('注册'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: _loading ? null : () => context.push('/login'),
            child: const Text('已有账号？去登录'),
          ),
        ],
      ),
    );
  }
}
