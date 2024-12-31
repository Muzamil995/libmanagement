import 'package:cloud_firestore/cloud_firestore.dart';

class MemberService {
  final _firestore = FirebaseFirestore.instance;

  // Add a new member to Firestore
  Future<void> addMember(String name, String email) async {
    try {
      // Add member details to Firestore
      await _firestore.collection('members').add({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding member: $e');
      throw e;
    }
  }

  // Fetch all members from Firestore
  Stream<List<Map<String, dynamic>>> fetchMembers() {
    try {
      return _firestore
          .collection('members')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'name': doc['name'],
            'email': doc['email'],
          };
        }).toList();
      });
    } catch (e) {
      print('Error fetching members: $e');
      throw e;
    }
  }

  // Update a member's details in Firestore
  Future<void> updateMember(String id, String name, String email) async {
    try {
      // Update member details in Firestore
      await _firestore.collection('members').doc(id).update({
        'name': name,
        'email': email,
      });
    } catch (e) {
      print('Error updating member: $e');
      throw e;
    }
  }

  // Delete a member from Firestore
  Future<void> deleteMember(String id) async {
    try {
      // Delete the member document from Firestore
      await _firestore.collection('members').doc(id).delete();
    } catch (e) {
      print('Error deleting member: $e');
      throw e;
    }
  }
}
