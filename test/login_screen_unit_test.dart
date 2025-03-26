import 'package:flutter_test/flutter_test.dart';

// Pure function to validate email format
bool isValidEmail(String email) {
  return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
}

// Pure function to validate password (minimum 6 characters)
bool isValidPassword(String password) {
  return password.length >= 6;
}

void main() {
  group('LoginScreen Unit Tests', () {
    test('validates email format correctly', () {
      expect(isValidEmail('test@example.com'), true);
      expect(isValidEmail('invalid-email'), false);
    });

    test('validates password length correctly', () {
      expect(isValidPassword('password'), true);
      expect(isValidPassword('pass'), false);
    });
  });
}