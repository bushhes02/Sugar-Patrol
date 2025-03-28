import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

// Service class for handling authentication with Firebase
class AuthService{

  final _auth = FirebaseAuth.instance; // Instance of FirebaseAuth

  // Creates a new user with email and password
  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password); // Attempt to create user
      return cred.user; // Return the created user 
    } catch(e) {
      log("Something went wrong"); //Log error if creation falls
    }
    return null; //Return null if creation fails
  }

  // Logs in an existing user with email and password
  Future<User?> loginUserWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password); // Login
      return cred.user; // Return logged in user
    } catch(e) {
      log("Something went wrong"); // Log error if login fails
    }
    return null; // Return null if login fails
  }
}

