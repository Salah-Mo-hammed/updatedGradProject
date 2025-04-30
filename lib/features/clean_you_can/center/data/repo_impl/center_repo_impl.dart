import 'package:dartz/dartz.dart';
import 'package:grad_project_ver_1/core/errors/failure.dart';
import 'package:grad_project_ver_1/features/auth/data/source/remote/auth_data_source.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/data/models/center_model.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/data/sources/remote/center_data_source.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/entities/center_entity.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/repo/center_repo.dart';
import 'package:grad_project_ver_1/features/clean_you_can/course/data/models/course_model.dart';
import 'package:grad_project_ver_1/features/clean_you_can/course/domain/entities/Course-entity.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/domain/entities/studentEntity.dart';

class CenterRepoImpl implements CenterRepo {
  CenterDataSource centerDataSource;
  CenterRepoImpl({
    required this.centerDataSource,
    required AuthDataSource authDataSource,
  });

  @override
  Future<Either<Failure, void>> createCenter(CenterEntity newCenter) {
    CenterModel newCenter0 = CenterModel(
      centerId: newCenter.centerId,
      name: newCenter.name,
      email: newCenter.email,
      phoneNumber: newCenter.phoneNumber,
      address: newCenter.address,
      description: newCenter.description,
    );
    return centerDataSource.createCenter(newCenter0);
  }

  @override
  Future<Either<Failure, CourseEntity>> addCourse(CourseEntity courseEntity) {
    CourseModel courseModel = CourseModel(
      courseId: courseEntity.courseId,
      title: courseEntity.title,
      description: courseEntity.description,
      centerId: courseEntity.centerId,
      price: courseEntity.price,
      startDate: courseEntity.startDate,
      endDate: courseEntity.endDate,
      topics: courseEntity.topics,
      maxStudents: courseEntity.maxStudents,
    );
    return centerDataSource.addCourse(courseModel);
  }

  @override
  Future<Either<Failure, String>> deleteCourse(String courseId) {
    return centerDataSource.deleteCourse(courseId);
  }

  @override
  Future<Either<Failure, List<CourseEntity>>> getCenterCourses(
    String centerId,
  ) {
    return centerDataSource.getCenterCourses(centerId);
  }

  @override
  Future<Either<Failure, List<StudentEntity>>> getCourseStudents(int courseId) {
    // TODO: implement getCourseStudents
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> updateCourse(
    CourseEntity courseEntity,
  ) async {
    CourseModel courseModel = CourseModel(
      courseId: courseEntity.courseId,
      title: courseEntity.title,
      description: courseEntity.description,
      centerId: courseEntity.centerId,
      price: courseEntity.price,
      startDate: courseEntity.startDate,
      endDate: courseEntity.endDate,
      topics: courseEntity.topics,
      maxStudents: courseEntity.maxStudents,
    );
    return centerDataSource.updateCourse(courseModel);
  }
}
