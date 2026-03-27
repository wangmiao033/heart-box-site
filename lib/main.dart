import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/auth/supabase_env.dart';
import 'core/db/app_database.dart';
import 'core/db/db_platform.dart';
import 'core/prefs/app_prefs.dart';
import 'core/routing/app_router.dart';
import 'core/security/lock_session.dart';
import 'core/security/pin_store.dart';
import 'core/theme/app_theme.dart';
import 'core/storage/journal_image_store.dart';
import 'data/journal_repository.dart';
import 'features/auth/auth_controller.dart';
import 'features/journal/journal_controller.dart';
import 'features/sync/sync_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  late final LockSession lockSession;
  late final JournalImageStore imageStore;
  late final JournalRepository repo;
  late final PinStore pinStore;
  late final JournalController journalController;
  late final AuthController authController;
  late final JournalSyncController journalSyncController;
  late final GoRouter router;

  try {
    await configureDatabaseForPlatform();
    await initializeDateFormatting('zh_CN');
    await AppPrefs.instance.load();
    await AppDatabase.instance.database;

    var supabaseReady = false;
    if (SupabaseEnv.isConfigured) {
      try {
        await Supabase.initialize(
          url: SupabaseEnv.url.trim(),
          anonKey: SupabaseEnv.anonKey.trim(),
        );
        supabaseReady = true;
      } catch (e, st) {
        debugPrint('Supabase.initialize failed: $e\n$st');
      }
    } else {
      debugPrint(
        'Supabase: 未设置 SUPABASE_URL / SUPABASE_ANON_KEY，云端账号功能已关闭。',
      );
    }

    lockSession = LockSession(AppPrefs.instance);
    await lockSession.bootstrap();

    imageStore = JournalImageStore();
    repo = JournalRepository(AppDatabase.instance, imageStore);
    pinStore = PinStore();
    journalController = JournalController(repo);
    authController = AuthController(supabaseReady: supabaseReady);
    journalSyncController = JournalSyncController(
      supabaseReady: supabaseReady,
      repository: repo,
      journal: journalController,
      prefs: AppPrefs.instance,
      auth: authController,
    );
    await journalController.refresh();

    router = createAppRouter(
      lock: lockSession,
      prefs: AppPrefs.instance,
    );
  } catch (e, st) {
    if (kIsWeb) {
      runApp(_BootstrapFailureApp(error: e, stackTrace: st));
      return;
    }
    Error.throwWithStackTrace(e, st);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppPrefs>.value(value: AppPrefs.instance),
        ChangeNotifierProvider<LockSession>.value(value: lockSession),
        Provider<JournalImageStore>.value(value: imageStore),
        Provider<JournalRepository>.value(value: repo),
        Provider<PinStore>.value(value: pinStore),
        ChangeNotifierProvider<JournalController>.value(
          value: journalController,
        ),
        ChangeNotifierProvider<AuthController>.value(value: authController),
        ChangeNotifierProvider<JournalSyncController>.value(
          value: journalSyncController,
        ),
      ],
      child: Consumer<AppPrefs>(
        builder: (context, prefs, _) {
          return MaterialApp.router(
            title: '心事匣',
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: prefs.themeMode,
            routerConfig: router,
            locale: const Locale('zh', 'CN'),
            supportedLocales: const [Locale('zh', 'CN')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    ),
  );
}

/// Web 上若初始化抛错，白屏看不出原因；直接展示异常便于排查。
class _BootstrapFailureApp extends StatelessWidget {
  const _BootstrapFailureApp({
    required this.error,
    required this.stackTrace,
  });

  final Object error;
  final StackTrace stackTrace;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '心事匣 · 启动失败',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Web 启动失败（请截图或复制下文）'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: SelectableText(
            '$error\n\n$stackTrace'
            '\n\n── 若刚改过代码仍看到旧错误：Chrome 按 Ctrl+Shift+R 硬性刷新；'
            '或 F12 → Application →「清除网站数据」后重开本站。',
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
        ),
      ),
    );
  }
}
