import 'package:dartz/dartz.dart';
import 'package:grad_project_ver_1/core/errors/failure.dart';
import 'package:grad_project_ver_1/features/clean_you_can/course/domain/entities/Course-entity.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/data/models/student_model.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/data/sources/remote/student_data_source.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/domain/entities/studentEntity.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/domain/repo/student_repo.dart';

class StudentRepoImpl implements StudentRepo {
  StudentDataSource studentDataSource;
  StudentRepoImpl({required this.studentDataSource });
  @override
  Future<Either<Failure, void>> createStudent(StudentEntity newStudent) {
    StudentModel studentModel=
    StudentModel(
      studentId: newStudent.studentId,
      name: newStudent.name,
      email: newStudent.email,
      phoneNumber: newStudent.phoneNumber,
      address: newStudent.address,
      photoUrl: newStudent.photoUrl,
      registerdCourses: newStudent.registerdCourses,
    );
    return studentDataSource.createStudent(studentModel);
  }

  @override
  Future<Either<Failure, List<CourseEntity>>> getAVaialableCourses() {
    return studentDataSource.getAVaialableCourses();
  }
}
