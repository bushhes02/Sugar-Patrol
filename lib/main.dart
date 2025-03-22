import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sugar Patrol',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: Color(0xFFFF6F61), // Coral (light mode)
        scaffoldBackgroundColor: Color(0xFFFAFAFA),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: Color(0xFFFF8A80), // Coral (dark mode)
        scaffoldBackgroundColor: Color(0xFF212121),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFFCFD8DC)),
          bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Color(0xFFCFD8DC)),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Color(0xFFCFD8DC)),
        ),
      ),
      home: LoginScreen(),
    );
  }
}
