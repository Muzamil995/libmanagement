import 'dart:convert'; // Import for base64Decode
import 'dart:typed_data'; // Import for Uint8List
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/book_services.dart';
import '../services/category_service.dart';
import 'books_screen.dart';
import 'category_screen.dart';
import 'profile.dart';
import 'members_screen.dart';

class DashboardView extends StatelessWidget {
  DashboardView({super.key});

  final CategoryService categoryService = CategoryService();
  final BookService bookService = BookService();

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600; // Check if the screen is mobile

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MembersScreen()));
            },
            child: Text("Members"),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Navigation Buttons (Responsive layout)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen())),
                        child: const Text("Categories"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BookScreen())),
                        child: const Text("Books"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen())),
                        child: const Text("Profile"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Categories Section
                  const Text("Categories", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 110,
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: categoryService.fetchCategories(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Center(child: Text("Error loading categories"));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text("No categories available"));
                        }

                        final categories = snapshot.data!;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            String base64Image = category['image'] ?? '';
                            Widget imageWidget = base64Image.isNotEmpty
                                ? Image.memory(base64Decode(base64Image), width: 80, height: 80, fit: BoxFit.cover)
                                : const Icon(Icons.category, size: 80); // Placeholder

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Column(
                                children: [
                                  imageWidget,
                                  const SizedBox(height: 5),
                                  Text(
                                    category['name'] ?? '',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Books Section
                  const Text("Books", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  StreamBuilder<List<Map<String, dynamic>>>(
                    stream: bookService.fetchBooks(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(child: Text("Error loading books"));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("No books available"));
                      }

                      final books = snapshot.data!;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isMobile ? 2 : 4, // 2 for mobile, 4 for tablet/desktop
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: isMobile ? 0.8 : 0.6, // Adjust aspect ratio for smaller screens
                        ),
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index];
                          String base64Image = book['image'] ?? '';
                          Widget imageWidget = base64Image.isNotEmpty
                              ? Image.memory(base64Decode(base64Image), fit: BoxFit.cover)
                              : const Icon(Icons.book, size: 80); // Placeholder

                          return Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(child: imageWidget),
                                const SizedBox(height: 5),
                                Text(
                                  book['name'] ?? '',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "by ${book['author'] ?? ''}",
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
