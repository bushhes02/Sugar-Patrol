import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sugar_patrol/settings_screen.dart';
import 'package:sugar_patrol/theme_provider.dart';
void main() {
  group('SettingsScreen Widget Tests', () {
    setUp(() async {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
    });

    // Widget Test 1: Displays current sugar limit from SharedPreferences
    testWidgets('displays current sugar limit from SharedPreferences', (WidgetTester tester) async {
      // Arrange
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('dailySugarLimit', 60.0);

      // Act
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          child: const MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Current Limit: 60.0g'), findsOneWidget);
      expect(find.text('60.0'), findsOneWidget); // In the TextField
    });

    // Widget Test 2: Toggles theme switch and updates UI
    testWidgets('toggles theme switch and updates UI', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          child: const MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert initial state (light mode)
      expect(find.byWidgetPredicate((widget) => widget is Switch && widget.value == false), findsOneWidget);

      // Act: Toggle the switch
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Assert: Switch is now on (dark mode)
      expect(find.byWidgetPredicate((widget) => widget is Switch && widget.value == true), findsOneWidget);
    });
  });
}
