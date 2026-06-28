import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:derosak_admin/features/lesson/data/models/lesson_mode.dart';
import 'package:derosak_admin/features/lesson/data/repositories/lesson_repo.dart';
import 'package:uuid/uuid.dart';



part 'lesson_state.dart';

class LessonCubit extends Cubit<LessonState> {
  LessonCubit({
    required this.repo,
  }) : super(LessonInitial());

  final LessonRepo repo;

  final Uuid _uuid = const Uuid();

  StreamSubscription? _subscription;

  ///==========================
  /// Get Lessons
  ///==========================

  void getLessons({
    required String stageId,
    required String gradeId,
    required String courseId,
  }) {
    emit(LessonLoading());

    _subscription?.cancel();

    _subscription = repo
        .getLessons(
          stageId: stageId,
          gradeId: gradeId,
          courseId: courseId,
        )
        .listen((result) {
      result.fold(
        (failure) {
          emit(LessonFailure(failure.errMessage));
        },
        (lessons) {
          emit(LessonLoaded(lessons));
        },
      );
    });
  }

  ///==========================
  /// Add Lesson
  ///==========================

  Future<void> addLesson({
    required String stageId,
    required String gradeId,
    required String courseId,
    required String title,
    required String description,
    required String videoUrl,
    required int order,
    required bool isFree,
    required bool isPublished,
  }) async {
    emit(LessonLoading());

    final lesson = LessonModel(
      id: _uuid.v4(),
      title: title,
      description: description,
      videoUrl: videoUrl,
      order: order,
      isFree: isFree,
      isPublished: isPublished,
      createdAt: Timestamp.now(),
    );

    final result = await repo.addLesson(
      stageId: stageId,
      gradeId: gradeId,
      courseId: courseId,
      lesson: lesson,
    );

    result.fold(
      (failure) {
        emit(LessonFailure(failure.errMessage));
      },
      (_) {
        emit(LessonSuccess());
      },
    );
  }

  ///==========================
  /// Update Lesson
  ///==========================

  Future<void> updateLesson({
    required String stageId,
    required String gradeId,
    required String courseId,
    required LessonModel lesson,
    required String title,
    required String description,
    required String videoUrl,
    required int order,
    required bool isFree,
    required bool isPublished,
  }) async {
    emit(LessonLoading());

    final updatedLesson = lesson.copyWith(
      title: title,
      description: description,
      videoUrl: videoUrl,
      order: order,
      isFree: isFree,
      isPublished: isPublished,
    );

    final result = await repo.updateLesson(
      stageId: stageId,
      gradeId: gradeId,
      courseId: courseId,
      lesson: updatedLesson,
    );

    result.fold(
      (failure) {
        emit(LessonFailure(failure.errMessage));
      },
      (_) {
        emit(LessonSuccess());
      },
    );
  }

  ///==========================
  /// Delete Lesson
  ///==========================

  Future<void> deleteLesson({
    required String stageId,
    required String gradeId,
    required String courseId,
    required String lessonId,
  }) async {
    emit(LessonLoading());

    final result = await repo.deleteLesson(
      stageId: stageId,
      gradeId: gradeId,
      courseId: courseId,
      lessonId: lessonId,
    );

    result.fold(
      (failure) {
        emit(LessonFailure(failure.errMessage));
      },
      (_) {
        emit(LessonSuccess());
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}