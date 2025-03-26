import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'main_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Welcome to",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "Sugar Patrol!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary, // Replace coral with primary blue
              ),
            ),
            const Text(
              "Smarter Tracking, Healthier Living!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 24),
            // Add "Email" text above the email TextField
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Email",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onBackground, // Match the theme's text color
                ),
              ),
            ),
            const SizedBox(height: 8), // Small spacing between label and TextField
            TextField(
              decoration: InputDecoration(
                hintText: "Enter your email", // Updated placeholder text
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 2.0), // Replace coral with primary blue
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 2.0), // Replace coral with primary blue
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 2.0), // Replace coral with primary blue
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 8),
            // Add "Password" text above the password TextField
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Password",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onBackground, // Match the theme's text color
                ),
              ),
            ),
            const SizedBox(height: 8), // Small spacing between label and TextField
            TextField(
              decoration: InputDecoration(
                hintText: "Enter your password", // Updated placeholder text
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 2.0), // Replace coral with primary blue
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 2.0), // Replace coral with primary blue
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 2.0), // Replace coral with primary blue
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary, // Replace coral with primary blue
                foregroundColor: Theme.of(context).colorScheme.onPrimary, // Use onPrimary for text/icon color
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text(
                "Login",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary, // Replace coral with primary blue
                      decoration: TextDecoration.underline,
                      decorationColor: Theme.of(context).colorScheme.primary, // Replace coral with primary blue
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
