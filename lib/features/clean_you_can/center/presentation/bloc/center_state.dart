import 'package:grad_project_ver_1/features/clean_you_can/course/domain/entities/course_entity.dart';

abstract class CenterState {
  const CenterState();
}

class CenterInitialState extends CenterState {
  const CenterInitialState();
}

class CenterCreatedState extends CenterState {}

class CenterLoadingState extends CenterState {}


class CenterAddedCourseState extends CenterState {
  CourseEntity courseEntity;
  CenterAddedCourseState({required this.courseEntity});
}
class CenterUpdatedCourseState extends CenterState {}


class CenterExceptionState extends CenterState {
  final String message;
  CenterExceptionState({required this.message});
}

class CenterGotCoursesState extends CenterState {
  List<CourseEntity> courses;
  CenterGotCoursesState({required this.courses});
}


