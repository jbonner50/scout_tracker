import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/services.dart';
import 'package:scout_tracker/services/database.dart';
import 'package:scout_tracker/services/storage.dart';

enum AuthResultStatus {
  successful,
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  undefined,
}

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  AuthResultStatus _status;

  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

  Future<AuthResultStatus> register({String email, String pass}) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      if (authResult.user != null) {
        _status = AuthResultStatus.successful;
        FirebaseUser user = authResult.user;
        // create a new document for the user with the uid
        String username = email.split('@')[0];
        await DatabaseService(uid: user.uid).createScout(username);
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  Future<AuthResultStatus> login({email, pass}) async {
    try {
      final authResult =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);

      if (authResult.user != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  Future<void> logout() async {
    // await _auth.signOut().catchError((error) => print(error.toString()));
    await _auth.signOut();
  }
}

class AuthExceptionHandler {
  static AuthResultStatus handleException(e) {
    var status;
    switch (e.code) {
      case "ERROR_INVALID_EMAIL":
        status = AuthResultStatus.invalidEmail;
        break;
      case "ERROR_WRONG_PASSWORD":
        status = AuthResultStatus.wrongPassword;
        break;
      case "ERROR_USER_NOT_FOUND":
        status = AuthResultStatus.userNotFound;
        break;
      case "ERROR_USER_DISABLED":
        status = AuthResultStatus.userDisabled;
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        status = AuthResultStatus.tooManyRequests;
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        status = AuthResultStatus.operationNotAllowed;
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        status = AuthResultStatus.emailAlreadyExists;
        break;
      default:
        status = AuthResultStatus.undefined;
    }
    return status;
  }

  ///
  /// Accepts AuthExceptionHandler.errorType
  ///
  static String generateExceptionMessage(exceptionCode) {
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = "Invalid email address.";
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = "Incorrect password.";
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = "User with this email doesn't exist.";
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = "User with this email has been disabled.";
        break;
      case AuthResultStatus.tooManyRequests:
        errorMessage = "Too many requests. Try again later.";
        break;
      case AuthResultStatus.operationNotAllowed:
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage =
            "The email has already been registered. Please login or reset your password.";
        break;
      default:
        errorMessage = "An undefined Error happened.";
    }

    return errorMessage;
  }
}

// // sign in with email and password
// Future login(String email, String password) async {
//   try {
//     AuthResult result = await _auth.signInWithEmailAndPassword(
//         email: email, password: password);
//     FirebaseUser user = result.user;
//     return _userFromFirebaseUser(user);
//   } catch (e) {
//     print(e.toString());
//     return null;
//   }
// }

// // register with email and password
// Future register(
//     String email, String password, int rank) async {
//   try {
//     AuthResult result = await _auth.createUserWithEmailAndPassword(
//         email: email, password: password);
//     FirebaseUser user = result.user;
//     // create a new document for the user with the uid
//     String username = email.split('@')[0];
//     await DatabaseService(uid: user.uid).createScout(username, rank);
//     print('registered');

//     return _userFromFirebaseUser(user);
//   } catch (e) {
//     print(e.toString());
//     return null;
//   }
// }
