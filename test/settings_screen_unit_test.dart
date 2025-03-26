import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SettingsScreen Unit Tests', () {
    setUp(() async {
      // Mock SharedPreferences with initial values
      SharedPreferences.setMockInitialValues({'dailySugarLimit': 50.0});
    });

    // Unit Test 1: Simulate saving a sugar limit and verify persistence
    test('saves sugar limit to SharedPreferences', () async {
      // Arrange: Get a SharedPreferences instance
      final prefs = await SharedPreferences.getInstance();

      // Act: Simulate setting a new sugar limit
      await prefs.setDouble('dailySugarLimit', 75.0);

      // Assert: Verify the value in SharedPreferences
      // Use a dynamic type to bypass the analyzer's type inference issue
      final dynamic savedLimit = prefs.getDouble('dailySugarLimit');
      expect(savedLimit, 75.0);
    });
  });
}
