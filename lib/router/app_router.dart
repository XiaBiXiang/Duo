import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../pages/home_page.dart';
import '../pages/task_detail_page.dart';
import '../pages/login_page.dart';
import '../pages/couple_pairing_page.dart';
import '../pages/settings_page.dart';
import '../providers/auth_provider.dart';
import '../providers/couple_provider.dart';

/// Router notifier that triggers GoRouter refresh when auth/couple state changes.
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen(authProvider, (_, __) => notifyListeners());
    _ref.listen(coupleProvider, (_, __) => notifyListeners());
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNavigator');

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: notifier,
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final couple = ref.read(coupleProvider);

      final isLoginRoute = state.matchedLocation == '/login';
      final isPairingRoute = state.matchedLocation == '/pairing';
      final isSettingsRoute = state.matchedLocation == '/settings';

      // Still loading → redirect to login page as loading screen
      if (auth.isLoading) return '/login';

      // Not logged in → login
      if (!auth.isAuthenticated) {
        return isLoginRoute ? null : '/login';
      }

      // Logged in but on login page → forward
      if (isLoginRoute) return '/';

      // Loading couple → stay put
      if (couple.isLoading) return null;

      // No couple space → pairing (allow settings too so user can see error)
      if (couple.couple == null) {
        if (isPairingRoute || isSettingsRoute) return null;
        return '/pairing';
      }

      // Not paired yet → stay on pairing
      if (!couple.isPaired) {
        return isPairingRoute ? null : '/pairing';
      }

      // On pairing but already paired → home
      if (isPairingRoute) return '/';

      // Settings page is fine for authenticated + paired users
      if (isSettingsRoute) return null;

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/pairing',
        builder: (context, state) => const CouplePairingPage(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/task/:id',
        builder: (context, state) {
          final taskId = state.pathParameters['id']!;
          return TaskDetailPage(taskId: taskId);
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
});
