import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

// Global ValueNotifier for toggling the theme easily
final ValueNotifier<ThemeMode> appThemeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const WamApp());
}

class WamApp extends StatelessWidget {
  const WamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appThemeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          title: 'WAM! - What\'s Above Me!',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.blueAccent,
            scaffoldBackgroundColor: Colors.lightBlue[100],
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blueAccent,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.cyanAccent,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.cyanAccent,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFF020617),
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}
