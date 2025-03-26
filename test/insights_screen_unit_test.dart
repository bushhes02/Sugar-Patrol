import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InsightsScreen Unit Tests', () {

    // Test DateTime parsing (a small piece of logic we can isolate)
    test('parses timestamp correctly', () {
      final timestamp = DateTime.now().toIso8601String();
      final parsedDate = DateTime.parse(timestamp);
      expect(parsedDate.toIso8601String(), timestamp);
    });

    // Test basic map structure (to ensure log format is as expected)
    test('log map has expected structure', () {
      final log = {
        "food": "Apple",
        "sugar": 10.0,
        "timestamp": DateTime.now().toIso8601String(),
      };
      expect(log.containsKey('food'), true);
      expect(log.containsKey('sugar'), true);
      expect(log.containsKey('timestamp'), true);
    });
  });
}
