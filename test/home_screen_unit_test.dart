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

    testWidgets('sorts logs low to high when selected', (WidgetTester tester) async {
      // Arrange: Mock logs with today’s data
      final logs = [
        {
          "food": "Cake",
          "sugar": 20.0,
          "timestamp": DateTime.now().toIso8601String(),
        },
        {
          "food": "Apple",
          "sugar": 10.0,
          "timestamp": DateTime.now().toIso8601String(),
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

      // Ensure the dropdown is set to "Low to High" (default)
      await tester.tap(find.text('Low to High'));
      await tester.pumpAndSettle();

      // Assert: Check if the logs are sorted low to high (Apple first, then Cake)
      final listTiles = find.byType(ListTile).evaluate().toList();
      final firstTile = listTiles[0].widget as ListTile;
      final secondTile = listTiles[1].widget as ListTile;

      // Find the Text widget inside the Row that contains the food name
      final firstTileFood = find.descendant(of: find.byWidget(firstTile), matching: find.text('Apple'));
      final secondTileFood = find.descendant(of: find.byWidget(secondTile), matching: find.text('Cake'));

      expect(firstTileFood, findsOneWidget);
      expect(secondTileFood, findsOneWidget);
    });

    testWidgets('sorts logs high to low when selected', (WidgetTester tester) async {
      // Arrange: Mock logs with today’s data
      final logs = [
        {
          "food": "Cake",
          "sugar": 20.0,
          "timestamp": DateTime.now().toIso8601String(),
        },
        {
          "food": "Apple",
          "sugar": 10.0,
          "timestamp": DateTime.now().toIso8601String(),
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

      // Change the dropdown to "High to Low"
      await tester.tap(find.text('Low to High')); // Open dropdown
      await tester.pumpAndSettle();
      await tester.tap(find.text('High to Low').last); // Select "High to Low"
      await tester.pumpAndSettle();

      // Assert: Check if the logs are sorted high to low (Cake first, then Apple)
      final listTiles = find.byType(ListTile).evaluate().toList();
      final firstTile = listTiles[0].widget as ListTile;
      final secondTile = listTiles[1].widget as ListTile;

      // Find the Text widget inside the Row that contains the food name
      final firstTileFood = find.descendant(of: find.byWidget(firstTile), matching: find.text('Cake'));
      final secondTileFood = find.descendant(of: find.byWidget(secondTile), matching: find.text('Apple'));

      expect(firstTileFood, findsOneWidget);
      expect(secondTileFood, findsOneWidget);
    });
  });
}