import 'package:grad_project_ver_1/features/clean_you_can/student/domain/entities/studentEntity.dart';

abstract class StudentEvent {}

class CreateStudentEvent extends StudentEvent {
  StudentEntity createStudent;
  CreateStudentEvent({required this.createStudent});
}

class GetAvailableAndMineCoursesEvent extends StudentEvent {
  String studentId;
  GetAvailableAndMineCoursesEvent({required this.studentId});
}

class EnrollInCourseEvent extends StudentEvent {
  String studentUid;
  String courseUid;

  EnrollInCourseEvent({
    required this.studentUid,
    required this.courseUid,
  });
}
