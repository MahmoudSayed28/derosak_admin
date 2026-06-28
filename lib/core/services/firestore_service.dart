import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Main Collection
  CollectionReference<Map<String, dynamic>> collection(
    String path,
  ) {
    return _firestore.collection(path);
  }

  /// Any Sub Collection
  CollectionReference<Map<String, dynamic>> subCollection(
    DocumentReference<Map<String, dynamic>> parent,
    String path,
  ) {
    return parent.collection(path);
  }

  /// Add
  Future<void> setDocument({
    required DocumentReference<Map<String, dynamic>> reference,
    required Map<String, dynamic> data,
  }) async {
    await reference.set(data);
  }

  /// Update
  Future<void> updateDocument({
    required DocumentReference<Map<String, dynamic>> reference,
    required Map<String, dynamic> data,
  }) async {
    await reference.update(data);
  }

  /// Delete
  Future<void> deleteDocument({
    required DocumentReference<Map<String, dynamic>> reference,
  }) async {
    await reference.delete();
  }

  /// Get One
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument({
    required DocumentReference<Map<String, dynamic>> reference,
  }) {
    return reference.get();
  }

  /// Stream Collection
  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection({
    required CollectionReference<Map<String, dynamic>> reference,
    String orderBy = "createdAt",
    bool descending = false,
  }) {
    return reference
        .orderBy(orderBy, descending: descending)
        .snapshots();
  }
}