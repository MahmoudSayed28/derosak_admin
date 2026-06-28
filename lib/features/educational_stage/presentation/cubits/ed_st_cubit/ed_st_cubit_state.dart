
import 'package:derosak_admin/features/educational_stage/data/models/educational_stage_model.dart';

sealed class EducationalStageState {
  const EducationalStageState();
}

final class EducationalStageInitial extends EducationalStageState {}

final class EducationalStageLoading extends EducationalStageState {}

final class EducationalStageSuccess extends EducationalStageState {}

final class EducationalStageFailure extends EducationalStageState {
  final String message;

  const EducationalStageFailure(this.message);
}

final class EducationalStageLoaded extends EducationalStageState {
  final List<EducationalStageModel> stages;

  const EducationalStageLoaded(this.stages);
}