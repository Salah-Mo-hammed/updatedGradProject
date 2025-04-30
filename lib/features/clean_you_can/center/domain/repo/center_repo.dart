import 'package:dartz/dartz.dart';
import 'package:grad_project_ver_1/core/errors/failure.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/entities/center_entity.dart';
import 'package:grad_project_ver_1/features/clean_you_can/course/domain/entities/Course-entity.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/domain/entities/studentEntity.dart';

abstract class CenterRepo {
  Future<Either<Failure, void>> createCenter(CenterEntity newCenter);
  Future<Either<Failure, CourseEntity>> addCourse(CourseEntity courseEntity);
  Future<Either<Failure, String>> updateCourse(CourseEntity courseEntity);
  Future<Either<Failure, String>> deleteCourse(String courseId);
  Future<Either<Failure, List<CourseEntity>>> getCenterCourses(
    String centerId,
  ); // each course entity have parameter called center (center who own the course)
  Future<Either<Failure, List<StudentEntity>>> getCourseStudents(int courseId);//! HERE CHANGE IT TO String 
}
