import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sugar_patrol/home_screen.dart';
import 'dart:convert';

void main() {
  group('HomeScreen Widget Tests', () {
    setUp(() async {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('totalSugarIntake displays today’s sugar correctly', (WidgetTester tester) async {
      // Arrange: Mock logs with today’s and yesterday’s data
      final logs = [
        {
          "food": "Apple",
          "sugar": 10.0,
          "timestamp": DateTime.now().toIso8601String(),
        },
        {
          "food": "Cake",
          "sugar": 20.0,
          "timestamp": DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
        },
      ];

      // Mock SharedPreferences to return these logs
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('foodLogs', logs.map((log) => jsonEncode(log)).toList());

      // Act: Build the HomeScreen widget
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Wait for the widget to load data
      await tester.pumpAndSettle();

      // Assert: Check if the total sugar intake is displayed as 10g
      expect(find.text('10g'), findsOneWidget);
    });

    testWidgets('displays no logs message when logs are empty', (WidgetTester tester) async {
      // Arrange: Mock empty SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('foodLogs', []);

      // Act: Build the HomeScreen widget
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Wait for the widget to load data
      await tester.pumpAndSettle();

      // Assert: Check if the "No logs yet" message is displayed
      expect(find.text('No logs yet. Add an entry!'), findsOneWidget);
    });

    testWidgets('adds a new log entry when FAB is tapped and form is submitted', (WidgetTester tester) async {
      // Arrange: Mock empty SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('foodLogs', []);

      // Act: Build the HomeScreen widget
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Wait for the widget to load data
      await tester.pumpAndSettle();

      // Tap the FloatingActionButton to open the dialog
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Enter data in the dialog
      await tester.enterText(find.widgetWithText(TextField, 'Food Item'), 'Banana');
      await tester.enterText(find.widgetWithText(TextField, 'Sugar Level (g)'), '15');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pumpAndSettle();

      // Assert: Check if the new log is displayed
      expect(find.text('Banana'), findsOneWidget);
      expect(find.text('15g'), findsOneWidget);
    });
  });
}
