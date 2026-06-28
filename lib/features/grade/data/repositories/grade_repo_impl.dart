import 'package:dartz/dartz.dart';

import '../../../../core/constants/app_collections.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/firestore_service.dart';
import '../models/grade_model.dart';
import 'grade_repo.dart';

class GradeRepoImpl implements GradeRepo {
  final FirestoreService firestoreService;

  GradeRepoImpl({
    required this.firestoreService,
  });

  @override
  Future<Either<Failure, Unit>> addGrade({
    required String stageId,
    required GradeModel grade,
  }) async {
    try {
      await firestoreService.addSubDocument(
        collection: AppCollections.educationalStages,
        documentId: stageId,
        subCollection: AppCollections.grades,
        subDocumentId: grade.id,
        data: grade.toJson(),
      );

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateGrade({
    required String stageId,
    required GradeModel grade,
  }) async {
    try {
      await firestoreService.updateSubDocument(
        collection: AppCollections.educationalStages,
        documentId: stageId,
        subCollection: AppCollections.grades,
        subDocumentId: grade.id,
        data: grade.toJson(),
      );

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteGrade({
    required String stageId,
    required String gradeId,
  }) async {
    try {
      await firestoreService.deleteSubDocument(
        collection: AppCollections.educationalStages,
        documentId: stageId,
        subCollection: AppCollections.grades,
        subDocumentId: gradeId,
      );

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<GradeModel>>> getGrades({
    required String stageId,
  }) async* {
    try {
      yield* firestoreService
          .getSubCollection(
            collection: AppCollections.educationalStages,
            documentId: stageId,
            subCollection: AppCollections.grades,
            orderBy: "order",
          )
          .map(
            (snapshot) => right(
              snapshot.docs
                  .map((e) => GradeModel.fromJson(e.data()))
                  .toList(),
            ),
          );
    } catch (e) {
      yield left(Failure(e.toString()));
    }
  }
}