import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Text Editing Controllers to fetch data from SharedPreferences
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  // Load saved user details and image from SharedPreferences
  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('name') ?? '';
      emailController.text = prefs.getString('email') ?? '';
      phoneController.text = prefs.getString('phone') ?? '';
      addressController.text = prefs.getString('address') ?? '';
      String? imagePath = prefs.getString('profileImage');
      if (imagePath != null && imagePath.isNotEmpty) {
        _image = File(imagePath);
      }
    });
  }

  // Pick image from gallery or camera and save its path
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImage', pickedFile.path);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Circular Avatar with Image Picker Button
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey.shade200,
                      child: _image == null
                          ? Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                          : ClipOval(
                        child: Image.file(
                          _image!,
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
            
                // Text Fields for User Data
                _buildTextField('Name', nameController),
                _buildTextField('Email', emailController),
                _buildTextField('Phone', phoneController),
                _buildTextField('Address', addressController),
            
                // Save Button
                ElevatedButton(
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('name', nameController.text);
                    await prefs.setString('email', emailController.text);
                    await prefs.setString('phone', phoneController.text);
                    await prefs.setString('address', addressController.text);
            
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile Updated")));
                  },
                  child: const Text("Save Profile"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable TextField Widget
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
