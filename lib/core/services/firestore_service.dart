import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ==========================
  /// Collection Reference
  /// ==========================

  CollectionReference<Map<String, dynamic>> collection(String collection) {
    return _firestore.collection(collection);
  }

  /// ==========================
  /// Add Document
  /// ==========================

  Future<void> addDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(collection).doc(documentId).set(data);
  }

  /// ==========================
  /// Update Document
  /// ==========================

  Future<void> updateDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(collection).doc(documentId).update(data);
  }

  /// ==========================
  /// Delete Document
  /// ==========================

  Future<void> deleteDocument({
    required String collection,
    required String documentId,
  }) async {
    await _firestore.collection(collection).doc(documentId).delete();
  }

  /// ==========================
  /// Get One Document
  /// ==========================

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument({
    required String collection,
    required String documentId,
  }) {
    return _firestore.collection(collection).doc(documentId).get();
  }

  /// ==========================
  /// Stream Collection
  /// ==========================

  Stream<QuerySnapshot<Map<String, dynamic>>> getCollection({
    required String collection,
    String orderBy = "createdAt",
    bool descending = false,
  }) {
    return _firestore
        .collection(collection)
        .orderBy(orderBy, descending: descending)
        .snapshots();
  }

  /// ==========================
  /// Stream Sub Collection
  /// ==========================

  Stream<QuerySnapshot<Map<String, dynamic>>> getSubCollection({
    required String collection,
    required String documentId,
    required String subCollection,
    String orderBy = "createdAt",
    bool descending = false,
  }) {
    return _firestore
        .collection(collection)
        .doc(documentId)
        .collection(subCollection)
        .orderBy(orderBy, descending: descending)
        .snapshots();
  }

  /// ==========================
  /// Server Timestamp
  /// ==========================

  Timestamp get serverTimestamp =>
      Timestamp.now(); // أو FieldValue.serverTimestamp() عند الإضافة مباشرة
}
