import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:derosak_admin/core/services/file_service.dart';
import 'package:derosak_admin/core/services/supabase_service.dart';
import 'package:derosak_admin/features/resources/data/models/resources_model.dart';
import 'package:derosak_admin/features/resources/data/repositories/resourses_repo.dart';
import 'package:derosak_admin/features/resources/presentation/cubits/resources_cubit/resources_state.dart';
import 'package:uuid/uuid.dart';



class ResourceCubit extends Cubit<ResourceState> {
  ResourceCubit({
    required this.repo,
    required this.filePickerService,
    required this.storageService,
  }) : super(ResourceInitial());

  final ResourceRepo repo;
  final FilePickerService filePickerService;
  final SupabaseStorageService storageService;

  final Uuid _uuid = const Uuid();

  StreamSubscription? _subscription;

  File? selectedFile;

  //==========================================
  // Pick File
  //==========================================

  Future<void> pickFile() async {
    selectedFile = await filePickerService.pickFile();
    emit(ResourceSuccess());
  }

  void clearFile() {
    selectedFile = null;
    emit(ResourceSuccess());
  }

  //==========================================
  // Get Resources
  //==========================================

  void getResources({
    required String stageId,
    required String gradeId,
    required String courseId,
    required String lessonId,
  }) {
    emit(ResourceLoading());

    _subscription?.cancel();

    _subscription = repo
        .getResources(
          stageId: stageId,
          gradeId: gradeId,
          courseId: courseId,
          lessonId: lessonId,
        )
        .listen((result) {
      result.fold(
        (failure) {
          emit(ResourceFailure(failure.errMessage));
        },
        (resources) {
          emit(ResourceLoaded(resources));
        },
      );
    });
  }

  //==========================================
  // Add Resource
  //==========================================

  Future<void> addResource({
    required String stageId,
    required String gradeId,
    required String courseId,
    required String lessonId,
    required String title,
    required String type,
    required int order,
    required bool isFree,
  }) async {
    emit(ResourceLoading());

    if (selectedFile == null) {
      emit(const ResourceFailure("Please Select File"));
      return;
    }

    final fileUrl = await storageService.uploadFile(
      file: selectedFile!,
      folder: "resources",
    );

    final resource = ResourceModel(
      id: _uuid.v4(),
      title: title,
      url: fileUrl,
      type: type,
      order: order,
      isFree: isFree,
      createdAt: Timestamp.now(),
    );

    final result = await repo.addResource(
      stageId: stageId,
      gradeId: gradeId,
      courseId: courseId,
      lessonId: lessonId,
      resource: resource,
    );

    result.fold(
      (failure) {
        emit(ResourceFailure(failure.errMessage));
      },
      (_) {
        selectedFile = null;
        emit(ResourceSuccess());
      },
    );
  }

  //==========================================
  // Update Resource
  //==========================================

  Future<void> updateResource({
    required String stageId,
    required String gradeId,
    required String courseId,
    required String lessonId,
    required ResourceModel resource,
    required String title,
    required String type,
    required int order,
    required bool isFree,
  }) async {
    emit(ResourceLoading());

    String fileUrl = resource.url;

    if (selectedFile != null) {
      await storageService.deleteFile(resource.url);

      fileUrl = await storageService.uploadFile(
        file: selectedFile!,
        folder: "resources",
      );
    }

    final updated = resource.copyWith(
      title: title,
      url: fileUrl,
      type: type,
      order: order,
      isFree: isFree,
    );

    final result = await repo.updateResource(
      stageId: stageId,
      gradeId: gradeId,
      courseId: courseId,
      lessonId: lessonId,
      resource: updated,
    );

    result.fold(
      (failure) {
        emit(ResourceFailure(failure.errMessage));
      },
      (_) {
        selectedFile = null;
        emit(ResourceSuccess());
      },
    );
  }

  //==========================================
  // Delete Resource
  //==========================================

  Future<void> deleteResource({
    required String stageId,
    required String gradeId,
    required String courseId,
    required String lessonId,
    required ResourceModel resource,
  }) async {
    emit(ResourceLoading());

    final result = await repo.deleteResource(
      stageId: stageId,
      gradeId: gradeId,
      courseId: courseId,
      lessonId: lessonId,
      resourceId: resource.id,
      fileUrl: resource.url,
    );

    result.fold(
      (failure) {
        emit(ResourceFailure(failure.errMessage));
      },
      (_) {
        emit(ResourceSuccess());
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}