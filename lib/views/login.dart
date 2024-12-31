import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterlearner/views/dashboard.dart';
import 'package:flutterlearner/views/sign_up.dart';
import 'package:flutterlearner/views/forgot_password.dart';

import '../services/auth.dart';


class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              // Welcome Image
              Center(
                child: Image.asset(
                  'assets/images/girlpic.jpeg',
                  height: 150,
                ),
              ),
              const SizedBox(height: 20),
              // Login Header
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              // Email Field
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'abc123@example.com',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Password Field
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: pwdController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Login Button
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                 onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });

                  // Get email and password from the controllers
                  String email = emailController.text.trim();
                  String password = pwdController.text.trim();

                  try {
                    User? user = await AuthServices().signInUser(email: email, password: password);

                    if (user != null) {
                      // If login is successful, navigate to the dashboard
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => DashboardView()),
                      );
                    } else {
                      // If login fails, show an error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Login failed. Please try again.")),
                      );
                    }
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Login failed: ${e.message}")),
                    );
                  } catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("An unexpected error occurred.")),
                    );
                  }

                  setState(() {
                    isLoading = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              // Forgot Password
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPasswordView(),
                    ),
                  );
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              // Sign Up
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterView(),
                    ),
                  );
                },
                child: const Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}