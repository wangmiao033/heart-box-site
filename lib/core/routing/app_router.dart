import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/calendar/calendar_page.dart';
import '../../features/compose/compose_page.dart';
import '../../features/detail/entry_detail_page.dart';
import '../../features/home/home_page.dart';
import '../../features/lock/lock_screen.dart';
import '../../features/review/review_page.dart';
import '../../features/settings/settings_page.dart';
import '../../features/shell/main_shell.dart';
import '../prefs/app_prefs.dart';
import '../security/lock_session.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter({
  required LockSession lock,
  required AppPrefs prefs,
}) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/home',
    refreshListenable: Listenable.merge([lock, prefs]),
    redirect: (context, state) {
      final loc = state.matchedLocation;
      if (prefs.lockEnabled && !lock.unlocked) {
        if (loc != '/lock') return '/lock';
        return null;
      }
      if (loc == '/lock') return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/lock',
        builder: (context, state) => const LockScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: HomePage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/calendar',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: CalendarPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/review',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: ReviewPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: SettingsPage(),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/compose',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final id = int.tryParse(state.uri.queryParameters['id'] ?? '');
          return ComposePage(entryId: id);
        },
      ),
      GoRoute(
        path: '/entry/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return EntryDetailPage(entryId: id);
        },
      ),
    ],
  );
}
