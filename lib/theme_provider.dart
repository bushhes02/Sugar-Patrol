import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Theme Provider class to manage light/dark theme state 
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemePreference();
  }

  // Loads saved theme preference from SharedPreferences
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  //Toggles theme and saves to SharedPreferences
  Future<void> toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = value;
    await prefs.setBool('isDarkMode', value);
    notifyListeners();
  }
}