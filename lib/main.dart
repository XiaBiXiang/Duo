import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'providers/settings_provider.dart';
import 'router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: DuoApp()));
}

class DuoApp extends ConsumerStatefulWidget {
  const DuoApp({super.key});

  @override
  ConsumerState<DuoApp> createState() => _DuoAppState();
}

class _DuoAppState extends ConsumerState<DuoApp> {
  // Stable key so MaterialApp keeps its internal state across theme rebuilds
  final _appKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(settingsProvider).isDarkMode;
    final router = ref.read(appRouterProvider);
    return MaterialApp.router(
      key: _appKey,
      title: 'Duo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
    );
  }
}
