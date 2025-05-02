import 'package:dartz/dartz.dart';
import 'package:grad_project_ver_1/core/errors/failure.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/domain/entities/studentEntity.dart';

abstract class StudentRepo {
  Future<Either<Failure, void>> createStudent(
    StudentEntity newStudent,
  );
  Future<Either<Failure, Map<String,dynamic>>>
  getAVaialableAndMineCourses(String studentId);
  Future<Either<Failure, Unit>> enrollInCourse(
    String studentId,
    String courseId,
  );
  // Future<Either<Failure, void>> updateStudentInfo(StudentEntity newStudent);
  //(future proparaty) Future<Either<Failure, void>> deleteStudent(int studentId);
}
