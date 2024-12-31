import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterView extends StatefulWidget {
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  bool isLoading = false;

  // Function to handle user registration and save data in SharedPreferences
  Future<void> registerUser() async {
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email cannot be empty")),
      );
      return;
    }
    if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password cannot be empty")),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      // Simulating registration logic here
      await Future.delayed(Duration(seconds: 2));

      // Save user data to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', nameController.text);
      await prefs.setString('email', emailController.text);
      await prefs.setString('phone', phoneController.text);
      await prefs.setString('address', addressController.text);

      setState(() {
        isLoading = false;
      });

      // Navigate to Profile Screen
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => ProfileScreen()),
      // );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Register Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 40),
          
              // Full Name Field
              buildTextField('NAME', 'Enter your full name', nameController),
              SizedBox(height: 20),
          
              // Email Field
              buildTextField('EMAIL', 'abc123@example.com', emailController),
              SizedBox(height: 20),
          
              // Password Field
              buildTextField('PASSWORD', 'Enter your password', passwordController, isPassword: true),
              SizedBox(height: 20),
          
              // Address Field
              buildTextField('ADDRESS', 'Enter your address', addressController),
              SizedBox(height: 20),
          
              // Phone Number Field
              buildTextField('PHONE NUMBER', 'Enter your phone number', phoneController),
              SizedBox(height: 40),
          
              // Sign Up Button
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: registerUser, // Call the register function here
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 40),
          
              // Back to Login
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Back to Login",
                  style: TextStyle(fontSize: 14, color: Colors.pink),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, String hint, TextEditingController controller, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[700], letterSpacing: 0.5),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Color(0xFFF1F3F4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
