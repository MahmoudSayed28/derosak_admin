import 'package:dartz/dartz.dart';
import 'package:derosak_admin/core/services/firestore_service.dart';
import 'package:derosak_admin/core/services/supabase_service.dart';

import '../../../../core/constants/app_collections.dart';
import '../../../../core/errors/failure.dart';
import '../models/educational_stage_model.dart';
import 'educational_stage_repo.dart';

class EducationalStageRepoImpl implements EducationalStageRepo {
  final FirestoreService firestoreService;
  final SupabaseStorageService storageService;

  EducationalStageRepoImpl({
    required this.firestoreService,
    required this.storageService,
  });

  @override
  Future<Either<Failure, Unit>> addStage(
    EducationalStageModel model,
  ) async {
    try {
      final stageRef = firestoreService
          .collection(AppCollections.educationalStages)
          .doc(model.id);

      await firestoreService.setDocument(
        reference: stageRef,
        data: model.toJson(),
      );

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateStage(
    EducationalStageModel model,
  ) async {
    try {
      final stageRef = firestoreService
          .collection(AppCollections.educationalStages)
          .doc(model.id);

      await firestoreService.updateDocument(
        reference: stageRef,
        data: model.toJson(),
      );

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteStage({
    required String stageId,
    required String imageUrl,
  }) async {
    try {
      if (imageUrl.isNotEmpty) {
        await storageService.deleteImage(imageUrl);
      }

      final stageRef = firestoreService
          .collection(AppCollections.educationalStages)
          .doc(stageId);

      await firestoreService.deleteDocument(
        reference: stageRef,
      );

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<EducationalStageModel>>> getStages() async* {
    try {
      final stagesRef = firestoreService.collection(
        AppCollections.educationalStages,
      );

      yield* firestoreService
          .streamCollection(
            reference: stagesRef,
          )
          .map(
            (snapshot) => right(
              snapshot.docs
                  .map(
                    (doc) => EducationalStageModel.fromJson(doc.data()),
                  )
                  .toList(),
            ),
          );
    } catch (e) {
      yield left(Failure(e.toString()));
    }
  }
}