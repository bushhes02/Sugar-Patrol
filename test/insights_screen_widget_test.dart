import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sugar_patrol/insights_screen.dart'; 

void main() {
  group('InsightsScreen Widget Tests', () {
    setUp(() async {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
    });

    // Widget Test 1: Displays "No food logs" message when logs are empty
    testWidgets('displays no food logs message when logs are empty', (WidgetTester tester) async {
      // Arrange: Mock empty SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('foodLogs', []);

      // Act: Build the InsightsScreen widget
      await tester.pumpWidget(
        const MaterialApp(
          home: InsightsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert: Check if the "No food logs" message is displayed
      expect(
        find.text('No food logs yet. Start logging food to see insights!'),
        findsOneWidget,
      );
      expect(find.byType(Card), findsNothing); // No cards should be displayed
      expect(find.byType(BarChart), findsNothing); // No bar chart should be displayed
    });
  });
}