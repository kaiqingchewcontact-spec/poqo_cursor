import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/storage_provider.dart';
import 'providers/user_provider.dart';
import 'screens/main_shell.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const PoqoApp(),
    ),
  );
}

class PoqoApp extends ConsumerStatefulWidget {
  const PoqoApp({super.key});

  @override
  ConsumerState<PoqoApp> createState() => _PoqoAppState();
}

class _PoqoAppState extends ConsumerState<PoqoApp> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider);
    final isDark = user.isDarkMode;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarContrastEnforced: false,
      ),
    );

    return MaterialApp(
      title: 'Poqo',
      debugShowCheckedModeBanner: false,
      theme: PoqoTheme.lightTheme(),
      darkTheme: PoqoTheme.darkTheme(),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: const MainShell(),
    );
  }
}
