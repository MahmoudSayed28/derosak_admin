part of 'grade_cubit.dart';

sealed class GradeState {
  const GradeState();
}

final class GradeInitial extends GradeState {}

final class GradeLoading extends GradeState {}

final class GradeSuccess extends GradeState {}

final class GradeFailure extends GradeState {
  final String message;

  const GradeFailure(this.message);
}

final class GradeLoaded extends GradeState {
  final List<GradeModel> grades;

  const GradeLoaded(this.grades);
}