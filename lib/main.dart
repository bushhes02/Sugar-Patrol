import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'login_screen.dart';

//Entry point of the application
void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  //Initialize Firebase based on platform (web or mobile)
  if(kIsWeb) {
    await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDWrWK9Ok_NS2GkO3Ya8mT_yPaoJXWi9tY",
      authDomain: "sugar-patrol.firebaseapp.com",
      projectId: "sugar-patrol",
      storageBucket: "sugar-patrol.firebasestorage.app",
      messagingSenderId: "1035495240216",
      appId: "1:1035495240216:web:229018e8291a4da97e096d"));
  } else {
    await Firebase.initializeApp();
    print("Firebase initialized successfully!");
  }
  
  // Run the app with Theme Provider as a ChangeNotifierProvider
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    print('Current theme mode: ${isDarkMode ? 'Dark' : 'Light'}');

    return MaterialApp(
      title: 'Sugar Patrol',
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF3206FF), 
          primaryContainer: Color(0xFF7986FF), 
          secondary: Color(0xFFB99688), 
          secondaryContainer: Color(0xFFD2B4A8),
          surface: Color(0xFFF5F5F5), 
          onPrimary: Colors.white,
          onSecondary: Color(0xFF212121),
          onSurface: Color(0xFF212121),
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
          color: const Color(0xFFE6EBFF), 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3206FF), 
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
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFF5F5F5),
          selectedItemColor: Color(0xFF3206FF),
          unselectedItemColor: Color(0xFF616161),
          selectedLabelStyle: TextStyle(color: Color(0xFF3206FF)),
          unselectedLabelStyle: TextStyle(color: Color(0xFF616161)),
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF7986FF), 
          primaryContainer: Color(0xFF3206FF),
          secondary: Color(0xFFD2B4A8), 
          secondaryContainer: Color(0xFFB99688),
          surface: Color(0xFF121212),
          onPrimary: Colors.white,
          onSecondary: Color(0xFF212121),
          onSurface: Colors.white,
          error: Color(0xFFEF5350),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Color(0xFFB0BEC5),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          color: const Color(0xFF2A2F5A), 
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
          color: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF7986FF),
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF121212),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey, 
          selectedLabelStyle: TextStyle(color: Colors.white),
          unselectedLabelStyle: TextStyle(color: Colors.grey),
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const LoginScreen(),
    );
  }
}
