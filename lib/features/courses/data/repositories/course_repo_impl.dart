import 'package:dartz/dartz.dart';
import 'package:derosak_admin/core/services/supabase_service.dart';

import '../../../../core/constants/app_collections.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/firestore_service.dart';
import '../models/course_model.dart';
import 'course_repo.dart';

class CourseRepoImpl implements CourseRepo {
  final FirestoreService firestoreService;
  final SupabaseStorageService storageService;

  CourseRepoImpl({
    required this.firestoreService,
    required this.storageService,
  });

  @override
  Future<Either<Failure, Unit>> addCourse({
    required String stageId,
    required String gradeId,
    required CourseModel course,
  }) async {
    try {
      final stageRef = firestoreService
          .collection(AppCollections.educationalStages)
          .doc(stageId);

      final gradeRef = firestoreService
          .subCollection(stageRef, AppCollections.grades)
          .doc(gradeId);

      final courseRef = firestoreService
          .subCollection(gradeRef, AppCollections.courses)
          .doc(course.id);

      await firestoreService.setDocument(
        reference: courseRef,
        data: course.toJson(),
      );

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateCourse({
    required String stageId,
    required String gradeId,
    required CourseModel course,
  }) async {
    try {
      final stageRef = firestoreService
          .collection(AppCollections.educationalStages)
          .doc(stageId);

      final gradeRef = firestoreService
          .subCollection(stageRef, AppCollections.grades)
          .doc(gradeId);

      final courseRef = firestoreService
          .subCollection(gradeRef, AppCollections.courses)
          .doc(course.id);

      await firestoreService.updateDocument(
        reference: courseRef,
        data: course.toJson(),
      );

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCourse({
    required String stageId,
    required String gradeId,
    required String courseId,
    required String imageUrl,
  }) async {
    try {
      if (imageUrl.isNotEmpty) {
        await storageService.deleteImage(imageUrl);
      }

      final stageRef = firestoreService
          .collection(AppCollections.educationalStages)
          .doc(stageId);

      final gradeRef = firestoreService
          .subCollection(stageRef, AppCollections.grades)
          .doc(gradeId);

      final courseRef = firestoreService
          .subCollection(gradeRef, AppCollections.courses)
          .doc(courseId);

      await firestoreService.deleteDocument(
        reference: courseRef,
      );

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<CourseModel>>> getCourses({
    required String stageId,
    required String gradeId,
  }) async* {
    try {
      final stageRef = firestoreService
          .collection(AppCollections.educationalStages)
          .doc(stageId);

      final gradeRef = firestoreService
          .subCollection(stageRef, AppCollections.grades)
          .doc(gradeId);

      final coursesRef = firestoreService.subCollection(
        gradeRef,
        AppCollections.courses,
      );

      yield* firestoreService
          .streamCollection(
            reference: coursesRef,
          )
          .map(
            (snapshot) => right(
              snapshot.docs
                  .map((doc) => CourseModel.fromJson(doc.data()))
                  .toList(),
            ),
          );
    } catch (e) {
      yield left(Failure(e.toString()));
    }
  }
}