part of 'lesson_cubit.dart';

sealed class LessonState {
  const LessonState();
}

final class LessonInitial extends LessonState {}

final class LessonLoading extends LessonState {}

final class LessonSuccess extends LessonState {}

final class LessonFailure extends LessonState {
  final String message;

  const LessonFailure(this.message);
}

final class LessonLoaded extends LessonState {
  final List<LessonModel> lessons;

  const LessonLoaded(this.lessons);
}
