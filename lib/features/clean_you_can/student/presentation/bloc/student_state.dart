import 'package:grad_project_ver_1/features/clean_you_can/course/domain/entities/Course-entity.dart';

abstract class StudentState {
  const StudentState();
}

class StudentInitialState extends StudentState {
  const StudentInitialState();
}

class StudentLoadingState extends StudentState {}

class StudentCreatedState extends StudentState {}

//class StudentRegistedCourseState extends StudentState{}

class StudentRefreshState extends StudentState {}

class StudentExceptionState extends StudentState {
  final message;
  StudentExceptionState({required this.message});
}
class StudentGotAvailableCoursesState extends StudentState{
  List<CourseEntity> availableCourses;
  StudentGotAvailableCoursesState({required this.availableCourses});
}