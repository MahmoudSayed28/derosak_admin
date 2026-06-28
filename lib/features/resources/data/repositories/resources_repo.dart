import 'package:dartz/dartz.dart';
import 'package:derosak_admin/features/resources/data/models/resources_model.dart';

import '../../../../core/errors/failure.dart';

abstract class ResourceRepo {
  Future<Either<Failure, Unit>> addResource({
    required String stageId,
    required String gradeId,
    required String courseId,
    required String lessonId,
    required ResourceModel resource,
  });

  Future<Either<Failure, Unit>> updateResource({
    required String stageId,
    required String gradeId,
    required String courseId,
    required String lessonId,
    required ResourceModel resource,
  });

  Future<Either<Failure, Unit>> deleteResource({
    required String stageId,
    required String gradeId,
    required String courseId,
    required String lessonId,
    required String resourceId,
    required String fileUrl,
  });

  Stream<Either<Failure, List<ResourceModel>>> getResources({
    required String stageId,
    required String gradeId,
    required String courseId,
    required String lessonId,
  });
}