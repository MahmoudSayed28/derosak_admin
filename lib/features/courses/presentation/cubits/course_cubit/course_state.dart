part of 'course_cubit.dart';

sealed class CourseState {
  const CourseState();
}

final class CourseInitial extends CourseState {}

final class CourseLoading extends CourseState {}

final class CourseSuccess extends CourseState {}

final class CourseFailure extends CourseState {
  final String message;

  const CourseFailure(this.message);
}

final class CourseLoaded extends CourseState {
  final List<CourseModel> courses;

  const CourseLoaded(this.courses);
}