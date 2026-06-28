import 'package:dartz/dartz.dart';
import 'package:derosak_admin/features/lesson/data/models/lesson_mode.dart';

import '../../../../core/constants/app_collections.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/firestore_service.dart';
import 'lesson_repo.dart';

class LessonRepoImpl implements LessonRepo {
  final FirestoreService firestoreService;

  LessonRepoImpl({required this.firestoreService});

  String _lessonsPath({
    required String stageId,
    required String gradeId,
    required String courseId,
  }) {
    return "${AppCollections.educationalStages}/$stageId/"
        "${AppCollections.grades}/$gradeId/"
        "${AppCollections.courses}/$courseId/"
        "${AppCollections.lessons}";
  }

  @override
  Future<Either<Failure, Unit>> addLesson({
    required String stageId,
    required String gradeId,
    required String courseId,
    required LessonModel lesson,
  }) async {
    try {
      await firestoreService.setDocumentByPath(
        path:
            "${_lessonsPath(stageId: stageId, gradeId: gradeId, courseId: courseId)}/${lesson.id}",
        data: lesson.toJson(),
      );

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateLesson({
    required String stageId,
    required String gradeId,
    required String courseId,
    required LessonModel lesson,
  }) async {
    try {
      await firestoreService.updateDocumentByPath(
        path:
            "${_lessonsPath(stageId: stageId, gradeId: gradeId, courseId: courseId)}/${lesson.id}",
        data: lesson.toJson(),
      );

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteLesson({
    required String stageId,
    required String gradeId,
    required String courseId,
    required String lessonId,
  }) async {
    try {
      await firestoreService.deleteDocumentByPath(
        path:
            "${_lessonsPath(stageId: stageId, gradeId: gradeId, courseId: courseId)}/$lessonId",
      );

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<LessonModel>>> getLessons({
    required String stageId,
    required String gradeId,
    required String courseId,
  }) async* {
    try {
      yield* firestoreService
          .streamCollectionByPath(
            path: _lessonsPath(
              stageId: stageId,
              gradeId: gradeId,
              courseId: courseId,
            ),
            orderBy: "order",
          )
          .map(
            (snapshot) => right(
              snapshot.docs
                  .map((doc) => LessonModel.fromJson(doc.data()))
                  .toList(),
            ),
          );
    } catch (e) {
      yield left(Failure(e.toString()));
    }
  }
}
