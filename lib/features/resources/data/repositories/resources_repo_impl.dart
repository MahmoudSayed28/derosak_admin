import 'package:dartz/dartz.dart';
import 'package:derosak_admin/core/constants/app_collections.dart';
import 'package:derosak_admin/core/errors/failure.dart';
import 'package:derosak_admin/core/services/firestore_service.dart';
import 'package:derosak_admin/core/services/supabase_service.dart';
import 'package:derosak_admin/features/resources/data/models/resources_model.dart';
import 'package:derosak_admin/features/resources/data/repositories/resources_repo.dart';

class ResourceRepoImpl implements ResourceRepo {
  final FirestoreService firestoreService;
  final SupabaseStorageService storageService;

  ResourceRepoImpl({
    required this.firestoreService,
    required this.storageService,
  });

  String _resourcesPath({
    required String stageId,
    required String gradeId,
    required String courseId,
    required String lessonId,
  }) {
    return "${AppCollections.educationalStages}/$stageId/"
        "${AppCollections.grades}/$gradeId/"
        "${AppCollections.courses}/$courseId/"
        "${AppCollections.lessons}/$lessonId/"
        "${AppCollections.resources}";
  }

  @override
  Future<Either<Failure, Unit>> addResource({
    required String stageId,
    required String gradeId,
    required String courseId,
    required String lessonId,
    required ResourceModel resource,
  }) async {
    try {
      await firestoreService.setDocumentByPath(
        path:
            "${_resourcesPath(stageId: stageId, gradeId: gradeId, courseId: courseId, lessonId: lessonId)}/${resource.id}",
        data: resource.toJson(),
      );

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateResource({
    required String stageId,
    required String gradeId,
    required String courseId,
    required String lessonId,
    required ResourceModel resource,
  }) async {
    try {
      await firestoreService.updateDocumentByPath(
        path:
            "${_resourcesPath(stageId: stageId, gradeId: gradeId, courseId: courseId, lessonId: lessonId)}/${resource.id}",
        data: resource.toJson(),
      );

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteResource({
    required String stageId,
    required String gradeId,
    required String courseId,
    required String lessonId,
    required String resourceId,
    required String fileUrl,
  }) async {
    try {
      await storageService.deleteFile(fileUrl);
      await firestoreService.deleteDocumentByPath(
        path:
            "${_resourcesPath(stageId: stageId, gradeId: gradeId, courseId: courseId, lessonId: lessonId)}/$resourceId",
      );

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<ResourceModel>>> getResources({
    required String stageId,
    required String gradeId,
    required String courseId,
    required String lessonId,
  }) async* {
    try {
      yield* firestoreService
          .streamCollectionByPath(
            path: _resourcesPath(
              stageId: stageId,
              gradeId: gradeId,
              courseId: courseId,
              lessonId: lessonId,
            ),
            orderBy: "order",
          )
          .map(
            (snapshot) => right(
              snapshot.docs
                  .map((e) => ResourceModel.fromJson(e.data()))
                  .toList(),
            ),
          );
    } catch (e) {
      yield left(Failure(e.toString()));
    }
  }
}
