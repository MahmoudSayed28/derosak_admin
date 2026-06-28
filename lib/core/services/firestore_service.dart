import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //====================================================
  // Collection Reference
  //====================================================

  CollectionReference<Map<String, dynamic>> collection(String path) {
    return _firestore.collection(path);
  }

  CollectionReference<Map<String, dynamic>> subCollection(
    DocumentReference<Map<String, dynamic>> parent,
    String path,
  ) {
    return parent.collection(path);
  }

  //====================================================
  // Document Reference
  //====================================================

  DocumentReference<Map<String, dynamic>> document(
    CollectionReference<Map<String, dynamic>> collection,
    String id,
  ) {
    return collection.doc(id);
  }

  //====================================================
  // CRUD باستخدام Reference
  //====================================================

  Future<void> setDocument({
    required DocumentReference<Map<String, dynamic>> reference,
    required Map<String, dynamic> data,
  }) async {
    await reference.set(data);
  }

  Future<void> updateDocument({
    required DocumentReference<Map<String, dynamic>> reference,
    required Map<String, dynamic> data,
  }) async {
    await reference.update(data);
  }

  Future<void> deleteDocument({
    required DocumentReference<Map<String, dynamic>> reference,
  }) async {
    await reference.delete();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument({
    required DocumentReference<Map<String, dynamic>> reference,
  }) {
    return reference.get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection({
    required CollectionReference<Map<String, dynamic>> reference,
    String orderBy = "createdAt",
    bool descending = false,
  }) {
    return reference.orderBy(orderBy, descending: descending).snapshots();
  }

  //====================================================
  // Path Helpers (للـ Lessons والـ Resources وما بعدهم)
  //====================================================

  CollectionReference<Map<String, dynamic>> collectionByPath(String path) {
    return _firestore.collection(path);
  }

  DocumentReference<Map<String, dynamic>> documentByPath(String path) {
    return _firestore.doc(path);
  }

  Future<void> setDocumentByPath({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.doc(path).set(data);
  }

  Future<void> updateDocumentByPath({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.doc(path).update(data);
  }

  Future<void> deleteDocumentByPath({required String path}) async {
    await _firestore.doc(path).delete();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocumentByPath({
    required String path,
  }) {
    return _firestore.doc(path).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollectionByPath({
    required String path,
    String orderBy = "createdAt",
    bool descending = false,
  }) {
    return _firestore
        .collection(path)
        .orderBy(orderBy, descending: descending)
        .snapshots();
  }
}
