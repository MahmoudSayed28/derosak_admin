import 'package:dartz/dartz.dart';
import 'package:derosak_admin/features/lesson/data/models/lesson_mode.dart';

import '../../../../core/errors/failure.dart';

abstract class LessonRepo {
  Future<Either<Failure, Unit>> addLesson({
    required String stageId,
    required String gradeId,
    required String courseId,
    required LessonModel lesson,
  });

  Future<Either<Failure, Unit>> updateLesson({
    required String stageId,
    required String gradeId,
    required String courseId,
    required LessonModel lesson,
  });

  Future<Either<Failure, Unit>> deleteLesson({
    required String stageId,
    required String gradeId,
    required String courseId,
    required String lessonId,
  });

  Stream<Either<Failure, List<LessonModel>>> getLessons({
    required String stageId,
    required String gradeId,
    required String courseId,
  });
}