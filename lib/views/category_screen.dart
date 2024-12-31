import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart'; // For ByteData conversion
import '../services/category_service.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _categoryService = CategoryService();
  File? _selectedImage;
  String? _base64Image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _openCategoryForm(),
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _categoryService.fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No categories found.'));
          }
          final categories = snapshot.data!;
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Card(
                child: ListTile(
                  leading: category['image'] != null && category['image'].isNotEmpty
                      ? Image.memory(
                    base64Decode(category['image']),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                      : Icon(Icons.category),
                  title: Text(category['name'] ?? 'Unnamed'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _openCategoryForm(
                          id: category['id'],
                          name: category['name'],
                          base64Image: category['image'],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await _categoryService.deleteCategory(category['id']);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Open the form for adding or editing a category
  void _openCategoryForm({String? id, String? name, String? base64Image}) async {
    final nameController = TextEditingController(text: name);
    _selectedImage = null; // Reset image for each form instance
    _base64Image = base64Image; // Set the existing Base64 image if available

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(id == null ? 'Add Category' : 'Edit Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Category Name'),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                icon: Icon(Icons.upload),
                label: Text('Upload Image'),
                onPressed: () async {
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    final file = File(pickedFile.path);
                    setState(() {
                      _selectedImage = file;
                    });
                    // Convert image to Base64
                    final bytes = await file.readAsBytes();
                    setState(() {
                      _base64Image = base64Encode(bytes);
                    });
                  }
                },
              ),
              if (_selectedImage != null)
                Text('New Image Selected'),
              if (_base64Image != null && _selectedImage == null)
                Column(
                  children: [
                    SizedBox(height: 10),
                    Image.memory(
                      base64Decode(_base64Image!),
                      width: 100,
                      height: 100,
                    ),
                    Text('Current Image'),
                  ],
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Category name cannot be empty')),
                  );
                  return;
                }
                if (id == null) {
                  await _categoryService.addCategory(
                    nameController.text.trim(),
                    _base64Image,
                  );
                } else {
                  await _categoryService.updateCategory(
                    id,
                    nameController.text.trim(),
                    _base64Image,
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
