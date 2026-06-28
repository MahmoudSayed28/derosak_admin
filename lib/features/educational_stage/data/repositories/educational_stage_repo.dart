import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../models/educational_stage_model.dart';

abstract class EducationalStageRepo {
  Future<Either<Failure, Unit>> addStage(
    EducationalStageModel model,
  );

  Future<Either<Failure, Unit>> updateStage(
    EducationalStageModel model,
  );

  Future<Either<Failure, Unit>> deleteStage({
    required String stageId,
    required String imageUrl,
  });

  Stream<Either<Failure, List<EducationalStageModel>>> getStages();
}