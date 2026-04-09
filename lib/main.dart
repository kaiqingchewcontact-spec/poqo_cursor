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

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

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

class PoqoApp extends ConsumerWidget {
  const PoqoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);

    return MaterialApp(
      title: 'Poqo',
      debugShowCheckedModeBanner: false,
      theme: PoqoTheme.lightTheme(),
      darkTheme: PoqoTheme.darkTheme(),
      themeMode: user.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const MainShell(),
    );
  }
}
