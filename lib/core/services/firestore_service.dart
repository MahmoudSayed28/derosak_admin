import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore
        .collection(collection)
        .doc(documentId)
        .set(data);
  }

  Future<void> updateDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore
        .collection(collection)
        .doc(documentId)
        .update(data);
  }

  Future<void> deleteDocument({
    required String collection,
    required String documentId,
  }) async {
    await _firestore
        .collection(collection)
        .doc(documentId)
        .delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCollection({
    required String collection,
  }) {
    return _firestore
        .collection(collection)
        .orderBy("createdAt", descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSubCollection({
    required String collection,
    required String documentId,
    required String subCollection,
  }) {
    return _firestore
        .collection(collection)
        .doc(documentId)
        .collection(subCollection)
        .orderBy("createdAt", descending: false)
        .snapshots();
  }
}