import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'core/db/app_database.dart';
import 'core/db/db_platform.dart';
import 'core/prefs/app_prefs.dart';
import 'core/routing/app_router.dart';
import 'core/security/lock_session.dart';
import 'core/security/pin_store.dart';
import 'core/theme/app_theme.dart';
import 'data/journal_repository.dart';
import 'features/journal/journal_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDatabaseForPlatform();
  await initializeDateFormatting('zh_CN');
  await AppPrefs.instance.load();
  await AppDatabase.instance.database;

  final lockSession = LockSession(AppPrefs.instance);
  await lockSession.bootstrap();

  final repo = JournalRepository(AppDatabase.instance);
  final pinStore = PinStore();
  final journalController = JournalController(repo);
  await journalController.refresh();

  final router = createAppRouter(
    lock: lockSession,
    prefs: AppPrefs.instance,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppPrefs>.value(value: AppPrefs.instance),
        ChangeNotifierProvider<LockSession>.value(value: lockSession),
        Provider<JournalRepository>.value(value: repo),
        Provider<PinStore>.value(value: pinStore),
        ChangeNotifierProvider<JournalController>.value(
          value: journalController,
        ),
      ],
      child: Consumer<AppPrefs>(
        builder: (context, prefs, _) {
          return MaterialApp.router(
            title: '心事匣',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
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
