import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  /// SignUp
  Future<User?> signUpUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      // Send email verification after successful sign-up
      await userCredential.user!.sendEmailVerification();
      return userCredential.user;
    } catch (e) {
      // Handle errors during sign-up
      print("SignUp Error: $e");
      return null;
    }
  }

  /// Login
  Future<User?> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      // Handle errors during login
      print("Login Error: $e");
      return null;
    }
  }

  /// Forgot Password
  Future<void> forgotPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      // Handle errors during password reset
      print("Forgot Password Error: $e");
    }
  }
}
