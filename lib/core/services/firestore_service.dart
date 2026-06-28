import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //===============================
  // Main Collection
  //===============================

  Future<void> addDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(collection).doc(documentId).set(data);
  }

  Future<void> updateDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(collection).doc(documentId).update(data);
  }

  Future<void> deleteDocument({
    required String collection,
    required String documentId,
  }) async {
    await _firestore.collection(collection).doc(documentId).delete();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument({
    required String collection,
    required String documentId,
  }) {
    return _firestore.collection(collection).doc(documentId).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCollection({
    required String collection,
    String orderBy = 'createdAt',
    bool descending = false,
  }) {
    return _firestore
        .collection(collection)
        .orderBy(orderBy, descending: descending)
        .snapshots();
  }

  //===============================
  // Sub Collection
  //===============================

  Future<void> addSubDocument({
    required String collection,
    required String documentId,
    required String subCollection,
    required String subDocumentId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore
        .collection(collection)
        .doc(documentId)
        .collection(subCollection)
        .doc(subDocumentId)
        .set(data);
  }

  Future<void> updateSubDocument({
    required String collection,
    required String documentId,
    required String subCollection,
    required String subDocumentId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore
        .collection(collection)
        .doc(documentId)
        .collection(subCollection)
        .doc(subDocumentId)
        .update(data);
  }

  Future<void> deleteSubDocument({
    required String collection,
    required String documentId,
    required String subCollection,
    required String subDocumentId,
  }) async {
    await _firestore
        .collection(collection)
        .doc(documentId)
        .collection(subCollection)
        .doc(subDocumentId)
        .delete();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getSubDocument({
    required String collection,
    required String documentId,
    required String subCollection,
    required String subDocumentId,
  }) {
    return _firestore
        .collection(collection)
        .doc(documentId)
        .collection(subCollection)
        .doc(subDocumentId)
        .get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSubCollection({
    required String collection,
    required String documentId,
    required String subCollection,
    String orderBy = 'createdAt',
    bool descending = false,
  }) {
    return _firestore
        .collection(collection)
        .doc(documentId)
        .collection(subCollection)
        .orderBy(orderBy, descending: descending)
        .snapshots();
  }
}