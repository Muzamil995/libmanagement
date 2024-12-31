import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  final _firestore = FirebaseFirestore.instance;

  /// Add a new category
  Future<void> addCategory(String name, String? base64Image) async {
    try {
      await _firestore.collection('categories').add({
        'name': name,
        'image': base64Image ?? '', // Store the Base64 string in Firestore
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding category: $e');
      rethrow;
    }
  }

  /// Update a category
  Future<void> updateCategory(String id, String name, String? base64Image) async {
    try {
      await _firestore.collection('categories').doc(id).update({
        'name': name,
        if (base64Image != null) 'image': base64Image, // Update the image if present
      });
    } catch (e) {
      print('Error updating category: $e');
      rethrow;
    }
  }

  /// Fetch all categories (unchanged)
  Stream<List<Map<String, dynamic>>> fetchCategories() {
    return _firestore.collection('categories').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'name': data['name'] ?? '',
          'image': data['image'], // Return the Base64 string directly
          'createdAt': data['createdAt'],
        };
      }).toList();
    });
  }

  /// Delete a category (unchanged)
  Future<void> deleteCategory(String id) async {
    try {
      await _firestore.collection('categories').doc(id).delete();
    } catch (e) {
      print('Error deleting category: $e');
      rethrow;
    }
  }
}
