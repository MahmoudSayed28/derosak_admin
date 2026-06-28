import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:derosak_admin/core/services/image_picker_service.dart';
import 'package:derosak_admin/core/services/supabase_service.dart';
import 'package:derosak_admin/features/educational_stage/data/models/educational_stage_model.dart';
import 'package:derosak_admin/features/educational_stage/data/repositories/educational_stage_repo.dart';
import 'package:derosak_admin/features/educational_stage/presentation/cubits/ed_st_cubit/ed_st_cubit_state.dart';
import 'package:uuid/uuid.dart';



class EducationalStageCubit extends Cubit<EducationalStageState> {
  EducationalStageCubit({
    required this.repo,
    required this.imagePickerService,
    required this.storageService,
  }) : super(EducationalStageInitial());

  final EducationalStageRepo repo;
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
    emit(EducationalStageSuccess());
  }

  void clearImage() {
    selectedImage = null;
    emit(EducationalStageSuccess());
  }

  ///==========================
  /// Get Stages
  ///==========================

  void getStages() {
    emit(EducationalStageLoading());

    _subscription?.cancel();

    _subscription = repo.getStages().listen((result) {
      result.fold(
        (failure) {
          emit(EducationalStageFailure(failure.errMessage));
        },
        (stages) {
          emit(EducationalStageLoaded(stages));
        },
      );
    });
  }

  ///==========================
  /// Add Stage
  ///==========================

  Future<void> addStage({
    required String stageName,
  }) async {
    emit(EducationalStageLoading());

    if (selectedImage == null) {
      emit(const EducationalStageFailure("Please select image"));
      return;
    }

    final imageUrl = await storageService.uploadImage(
      file: selectedImage!,
      folder: "educational_stages",
    );

    final model = EducationalStageModel(
      id: _uuid.v4(),
      name: stageName,
      image: imageUrl,
      createdAt: Timestamp.now(),
    );

    final result = await repo.addStage(model);

    result.fold(
      (failure) {
        emit(EducationalStageFailure(failure.errMessage));
      },
      (_) {
        selectedImage = null;
        emit(EducationalStageSuccess());
      },
    );
  }

  ///==========================
  /// Update Stage
  ///==========================

  Future<void> updateStage(
    EducationalStageModel stage,
  ) async {
    emit(EducationalStageLoading());

    String image = stage.image;

    if (selectedImage != null) {
      await storageService.deleteImage(stage.image);

      image = await storageService.uploadImage(
        file: selectedImage!,
        folder: "educational_stages",
      );
    }

    final updated = stage.copyWith(
      image: image,
    );

    final result = await repo.updateStage(updated);

    result.fold(
      (failure) {
        emit(EducationalStageFailure(failure.errMessage));
      },
      (_) {
        selectedImage = null;
        emit(EducationalStageSuccess());
      },
    );
  }

  ///==========================
  /// Delete Stage
  ///==========================

  Future<void> deleteStage(
    EducationalStageModel model,
  ) async {
    emit(EducationalStageLoading());

    final result = await repo.deleteStage(
      stageId: model.id,
      imageUrl: model.image,
    );

    result.fold(
      (failure) {
        emit(EducationalStageFailure(failure.errMessage));
      },
      (_) {
        emit(EducationalStageSuccess());
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}