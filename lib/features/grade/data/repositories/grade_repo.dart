import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../models/grade_model.dart';

abstract class GradeRepo {
  Future<Either<Failure, Unit>> addGrade({
    required String stageId,
    required GradeModel grade,
  });

  Future<Either<Failure, Unit>> updateGrade({
    required String stageId,
    required GradeModel grade,
  });

  Future<Either<Failure, Unit>> deleteGrade({
    required String stageId,
    required String gradeId,
  });

  Stream<Either<Failure, List<GradeModel>>> getGrades({
    required String stageId,
  });
}