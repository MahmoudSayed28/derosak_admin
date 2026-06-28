import 'package:dartz/dartz.dart';
import 'package:derosak_admin/core/services/supabase_service.dart';

import '../../../../core/constants/app_collections.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/firestore_service.dart';
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
      EducationalStageModel model) async {
    try {
      await firestoreService.addDocument(
        collection: AppCollections.educationalStages,
        documentId: model.id,
        data: model.toJson(),
      );

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateStage(
      EducationalStageModel model) async {
    try {
      await firestoreService.updateDocument(
        collection: AppCollections.educationalStages,
        documentId: model.id,
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
      await storageService.deleteImage(imageUrl);

      await firestoreService.deleteDocument(
        collection: AppCollections.educationalStages,
        documentId: stageId,
      );

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<EducationalStageModel>>> getStages() async* {
    try {
      yield* firestoreService
          .getCollection(collection: AppCollections.educationalStages)
          .map(
            (snapshot) => right(
              snapshot.docs
                  .map(
                    (e) => EducationalStageModel.fromJson(e.data()),
                  )
                  .toList(),
            ),
          );
    } catch (e) {
      yield left(Failure(e.toString()));
    }
  }
}