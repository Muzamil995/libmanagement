import 'package:cloud_firestore/cloud_firestore.dart';

class BookService {
  final _firestore = FirebaseFirestore.instance;

  // Add a book with its details
  Future<void> addBook(
      String name,
      String authorName,
      int totalPages,
      int stock,
      String categoryId,
      String? base64Image) async {
    try {
      // Add the book data to Firestore
      await _firestore.collection('books').add({
        'name': name,
        'authorName': authorName,
        'totalPages': totalPages,
        'stock': stock,
        'catID': categoryId,
        'image': base64Image ?? '', // Store Base64 string or empty if null
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding book: $e');
      rethrow; // Rethrow to be handled by the caller
    }
  }

  // Fetch books in real-time
  Stream<List<Map<String, dynamic>>> fetchBooks() {
    return _firestore.collection('books').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'authorName': doc['authorName'],
          'totalPages': doc['totalPages'],
          'stock': doc['stock'],
          'catID': doc['catID'],
          'image': doc['image'], // Retrieve Base64 string from Firestore
          'createdAt': doc['createdAt'],
        };
      }).toList();
    });
  }

  // Update an existing book's details
  Future<void> updateBook(
      String id,
      String name,
      String authorName,
      int totalPages,
      int stock,
      String? base64Image) async {
    try {
      // Update the book in Firestore
      await _firestore.collection('books').doc(id).update({
        'name': name,
        'authorName': authorName,
        'totalPages': totalPages,
        'stock': stock,
        if (base64Image != null) 'image': base64Image, // Update Base64 image if provided
      });
    } catch (e) {
      print('Error updating book: $e');
      rethrow;
    }
  }

  // Delete a book from Firestore
  Future<void> deleteBook(String id) async {
    try {
      await _firestore.collection('books').doc(id).delete();
    } catch (e) {
      print('Error deleting book: $e');
      rethrow;
    }
  }
}
