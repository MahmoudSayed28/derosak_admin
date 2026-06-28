import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:derosak_admin/core/services/image_picker_service.dart';
import 'package:derosak_admin/core/services/supabase_service.dart';
import 'package:derosak_admin/features/courses/data/models/course_model.dart';
import 'package:derosak_admin/features/courses/data/repositories/course_repo.dart';
import 'package:uuid/uuid.dart';



part 'course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  CourseCubit({
    required this.repo,
    required this.imagePickerService,
    required this.storageService,
  }) : super(CourseInitial());

  final CourseRepo repo;
  final ImagePickerService imagePickerService;
  final SupabaseStorageService storageService;

  final Uuid _uuid = const Uuid();

  StreamSubscription? _subscription;

  File? selectedImage;

  ///==========================
  /// Pick Image
  ///==========================

  Future<void> pickImage() async {
    selectedImage = await imagePickerService.pickImage();
    emit(CourseSuccess());
  }

  void clearImage() {
    selectedImage = null;
    emit(CourseSuccess());
  }

  ///==========================
  /// Get Courses
  ///==========================

  void getCourses({
    required String stageId,
    required String gradeId,
  }) {
    emit(CourseLoading());

    _subscription?.cancel();

    _subscription = repo
        .getCourses(
          stageId: stageId,
          gradeId: gradeId,
        )
        .listen((result) {
      result.fold(
        (failure) {
          emit(CourseFailure(failure.errMessage));
        },
        (courses) {
          emit(CourseLoaded(courses));
        },
      );
    });
  }

  ///==========================
  /// Add Course
  ///==========================

  Future<void> addCourse({
  required String stageId,
  required String gradeId,
  required String title,
  required String description,
  required String teacherName,
  required double price,
  required bool isFree,
  required bool isPublished,
  required int order,
}) async {
  emit(CourseLoading());

  if (selectedImage == null) {
    emit(const CourseFailure("Please Select Image"));
    return;
  }

  final imageUrl = await storageService.uploadImage(
    file: selectedImage!,
    folder: "courses",
  );

  final model = CourseModel(
    id: _uuid.v4(),
    title: title,
    description: description,
    teacherName: teacherName,
    image: imageUrl,
    price: price,
    isFree: isFree,
    isPublished: isPublished,
    order: order,
    createdAt: Timestamp.now(),
  );

  final result = await repo.addCourse(
    stageId: stageId,
    gradeId: gradeId,
    course: model,
  );

  result.fold(
    (failure) {
      emit(CourseFailure(failure.errMessage));
    },
    (_) {
      selectedImage = null;
      emit(CourseSuccess());
    },
  );
}
  ///==========================
  /// Update Course
  ///==========================

  Future<void> updateCourse({
    required String stageId,
    required String gradeId,
    required CourseModel course,
  }) async {
    emit(CourseLoading());

    String image = course.image;

    if (selectedImage != null) {
      await storageService.deleteImage(course.image);

      image = await storageService.uploadImage(
        file: selectedImage!,
        folder: "courses",
      );
    }

    final updatedCourse = course.copyWith(
      image: image,
    );

    final result = await repo.updateCourse(
      stageId: stageId,
      gradeId: gradeId,
      course: updatedCourse,
    );

    result.fold(
      (failure) {
        emit(CourseFailure(failure.errMessage));
      },
      (_) {
        selectedImage = null;
        emit(CourseSuccess());
      },
    );
  }

  ///==========================
  /// Delete Course
  ///==========================

  Future<void> deleteCourse({
    required String stageId,
    required String gradeId,
    required CourseModel course,
  }) async {
    emit(CourseLoading());

    final result = await repo.deleteCourse(
      stageId: stageId,
      gradeId: gradeId,
      courseId: course.id,
      imageUrl: course.image,
    );

    result.fold(
      (failure) {
        emit(CourseFailure(failure.errMessage));
      },
      (_) {
        emit(CourseSuccess());
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}