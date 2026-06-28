import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../models/course_model.dart';

abstract class CourseRepo {
  Future<Either<Failure, Unit>> addCourse({
    required String stageId,
    required String gradeId,
    required CourseModel course,
  });

  Future<Either<Failure, Unit>> updateCourse({
    required String stageId,
    required String gradeId,
    required CourseModel course,
  });

  Future<Either<Failure, Unit>> deleteCourse({
    required String stageId,
    required String gradeId,
    required String courseId,
    required String imageUrl,
  });

  Stream<Either<Failure, List<CourseModel>>> getCourses({
    required String stageId,
    required String gradeId,
  });
}