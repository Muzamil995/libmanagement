import 'dart:convert'; // For base64 encoding and decoding
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/book_services.dart';

class BookScreen extends StatefulWidget {
  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final _bookService = BookService();
  File? _selectedImage;
  String? _selectedImageBase64;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _openBookForm(),
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _bookService.fetchBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No books found.'));
          }
          final books = snapshot.data!;
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              // Decode base64 string to image for display
              Widget leadingImage = Icon(Icons.book);
              if (book['image'] != null) {
                try {
                  final decodedBytes = base64Decode(book['image']);
                  leadingImage = Image.memory(decodedBytes, width: 50, height: 50, fit: BoxFit.cover);
                } catch (e) {
                  print('Error decoding base64 image: $e');
                }
              }
              return Card(
                child: ListTile(
                  leading: leadingImage,
                  title: Text(book['name']),
                  subtitle: Text('Author: ${book['authorName']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _openBookForm(
                          id: book['id'],
                          name: book['name'],
                          authorName: book['authorName'],
                          totalPages: book['totalPages'],
                          stock: book['stock'],
                          imageBase64: book['image'],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          try {
                            await _bookService.deleteBook(book['id']);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Book deleted successfully!')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to delete book: $e')),
                            );
                          }
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

  void _openBookForm({
    String? id,
    String? name,
    String? authorName,
    int? totalPages,
    int? stock,
    String? imageBase64,
  }) async {
    final nameController = TextEditingController(text: name);
    final authorController = TextEditingController(text: authorName);
    final pagesController = TextEditingController(text: totalPages?.toString());
    final stockController = TextEditingController(text: stock?.toString());

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(id == null ? 'Add Book' : 'Edit Book'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Book Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter book name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: authorController,
                    decoration: InputDecoration(labelText: 'Author Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter author name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: pagesController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Total Pages'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter total pages';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: stockController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Stock'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter stock';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: Icon(Icons.upload),
                    label: Text('Upload Image'),
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          _selectedImage = File(pickedFile.path);
                          _selectedImageBase64 = base64Encode(_selectedImage!.readAsBytesSync());
                        });
                      }
                    },
                  ),
                  if (_selectedImageBase64 != null || imageBase64 != null)
                    Text('Image selected'),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    if (id == null) {
                      await _bookService.addBook(
                        nameController.text,
                        authorController.text,
                        int.parse(pagesController.text),
                        int.parse(stockController.text),
                        'categoryId',
                        _selectedImageBase64,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Book added successfully!')),
                      );
                    } else {
                      await _bookService.updateBook(
                        id,
                        nameController.text,
                        authorController.text,
                        int.parse(pagesController.text),
                        int.parse(stockController.text),
                        _selectedImageBase64 ?? imageBase64,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Book updated successfully!')),
                      );
                    }
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to save book: $e')),
                    );
                  }
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
