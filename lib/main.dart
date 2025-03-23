import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sugar Patrol',
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF3206FF), // Dark Blue
          primaryContainer: Color(0xFF7986FF), // Light Blue
          secondary: Color(0xFFB99688), // Muted Rose
          secondaryContainer: Color(0xFFD2B4A8),
          surface: Color(0xFFFFFFFF), // White
          background: Color(0xFFF5F5F5), // Light Grey
          onPrimary: Colors.white,
          onSecondary: Color(0xFF212121),
          onSurface: Color(0xFF212121),
          onBackground: Color(0xFF212121),
          error: Color(0xFFD32F2F),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Color(0xFF212121),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Color(0xFF616161),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          color: Color(0xFFE6EBFF), // Washed-Out Light Blue
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3206FF), // Dark Blue
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF212121),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF3206FF),
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF7986FF), // Light Blue
          primaryContainer: Color(0xFF3206FF),
          secondary: Color(0xFFD2B4A8), // Light Rose
          secondaryContainer: Color(0xFFB99688),
          surface: Color(0xFF1E1E1E),
          background: Color(0xFF121212),
          onPrimary: Colors.white,
          onSecondary: Color(0xFF212121),
          onSurface: Color(0xFFCFD8DC),
          onBackground: Color(0xFFCFD8DC),
          error: Color(0xFFEF5350),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFCFD8DC),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Color(0xFFCFD8DC),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Color(0xFFB0BEC5),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          color: Color(0xFF2A2F5A), // Darker shade for dark mode
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7986FF),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFCFD8DC),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF7986FF),
          foregroundColor: Colors.white,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}


