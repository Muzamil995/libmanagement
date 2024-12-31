import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


import '../models/usermodel.dart';


class UserServices {
  final CollectionReference _userCollection =
  FirebaseFirestore.instance.collection('users');

  /// Fetch all users as a stream
  Stream<List<UserModel>> getAllUsers() {
    return _userCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  /// Add a new user
  Future<void> addUser(UserModel user, File? profileImage) async {
    try {
      String? imageUrl;
      if (profileImage != null) {
        imageUrl = await _uploadImage(profileImage, user.id);
      }

      final userData = user.toMap();
      if (imageUrl != null) {
        userData['imageUrl'] = imageUrl;
      }

      await _userCollection.doc(user.id).set(userData);
    } catch (e) {
      print('Error adding user: $e');
      rethrow;
    }
  }

  /// Update user details
  Future<void> updateUser(UserModel user, File? profileImage) async {
    try {
      String? imageUrl;
      if (profileImage != null) {
        imageUrl = await _uploadImage(profileImage, user.id);
      }

      final updatedData = user.toMap();
      if (imageUrl != null) {
        updatedData['imageUrl'] = imageUrl;
      }

      await _userCollection.doc(user.id).update(updatedData);
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  /// Delete a user
  Future<void> deleteUser(String userId) async {
    try {
      await _userCollection.doc(userId).delete();
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  /// Upload profile image to Firebase Storage
  Future<String> _uploadImage(File file, String userId) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$userId.jpg');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }
}
