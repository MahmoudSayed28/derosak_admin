import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:derosak_admin/features/grade/data/models/grade_model.dart';
import 'package:derosak_admin/features/grade/data/repositories/grade_repo.dart';
import 'package:uuid/uuid.dart';


part 'grade_state.dart';

class GradeCubit extends Cubit<GradeState> {
  GradeCubit({
    required this.repo,
  }) : super(GradeInitial());

  final GradeRepo repo;

  final Uuid _uuid = const Uuid();

  StreamSubscription? _subscription;

  /// ==========================
  /// Get Grades
  /// ==========================

  void getGrades({
    required String stageId,
  }) {
    emit(GradeLoading());

    _subscription?.cancel();

    _subscription = repo.getGrades(stageId: stageId).listen(
      (result) {
        result.fold(
          (failure) {
            emit(GradeFailure(failure.errMessage));
          },
          (grades) {
            emit(GradeLoaded(grades));
          },
        );
      },
    );
  }

  /// ==========================
  /// Add Grade
  /// ==========================

  Future<void> addGrade({
    required String stageId,
    required String name,
    required int order,
  }) async {
    emit(GradeLoading());

    final grade = GradeModel(
      id: _uuid.v4(),
      name: name,
      order: order,
      createdAt: Timestamp.now(),
    );

    final result = await repo.addGrade(
      stageId: stageId,
      grade: grade,
    );

    result.fold(
      (failure) => emit(
        GradeFailure(failure.errMessage),
      ),
      (_) => emit(
        GradeSuccess(),
      ),
    );
  }

  /// ==========================
  /// Update Grade
  /// ==========================

  Future<void> updateGrade({
    required String stageId,
    required GradeModel grade,
  }) async {
    emit(GradeLoading());

    final result = await repo.updateGrade(
      stageId: stageId,
      grade: grade,
    );

    result.fold(
      (failure) => emit(
        GradeFailure(failure.errMessage),
      ),
      (_) => emit(
        GradeSuccess(),
      ),
    );
  }

  /// ==========================
  /// Delete Grade
  /// ==========================

  Future<void> deleteGrade({
    required String stageId,
    required String gradeId,
  }) async {
    emit(GradeLoading());

    final result = await repo.deleteGrade(
      stageId: stageId,
      gradeId: gradeId,
    );

    result.fold(
      (failure) => emit(
        GradeFailure(failure.errMessage),
      ),
      (_) => emit(
        GradeSuccess(),
      ),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}