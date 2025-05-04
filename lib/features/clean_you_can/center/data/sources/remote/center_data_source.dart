// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:grad_project_ver_1/core/errors/failure.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/data/models/center_model.dart';
import 'package:grad_project_ver_1/features/clean_you_can/course/data/models/course_model.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/data/models/student_model.dart';

class CenterDataSource {
  final _firestore = FirebaseFirestore.instance;

  Future<Either<Failure, void>> createCenter(CenterModel newCenter) async {
    try {
      await _firestore
          .collection('Centers')
          .doc(newCenter.centerId)
          .set(newCenter.toJson());
      await _firestore.collection("Users").doc(newCenter.centerId).update({
        'isCompletedInfo': true,
      });
      print(
        "*************************done creating Center and adding to firestore",
      );
      // ignore: void_checks
      return Right(unit);
    } on FirebaseException catch (e) {
      return Left(DatabaseFailure(e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, CourseModel>> addCourse(
    CourseModel courseModel,
  ) async {
    print(
      "***************************************************************************************************************************************************** we are now un data sourse",
    );
    try {
      print(
        "***************************************************************************************************************************************************** we are now in try ",
      );
      final docRef = _firestore.collection('Courses').doc();
      print(
        "***************************************************************************************************************************************************** we are now afetr docref sourse",
      );
      print(
        "***************************************************************************************************************************************************** *********************************************************************************************************************************** this is  deoc ref ${docRef.id}",
      );
      //generate uniqe id for course in courses collection

      // final newCourseModel = CourseModel(
      //   courseId: docRef.id,
      //   title: courseModel.title,
      //   description: courseModel.description,
      //   centerId: courseModel.centerId,
      //   price: courseModel.price,
      //   startDate: courseModel.startDate,
      //   endDate: courseModel.endDate,
      //   topics: courseModel.topics,
      //   maxStudents: courseModel.maxStudents,
      // );
      await docRef.set({});
      final newCourseModel = courseModel.copyWith(
        courseId: docRef.id,
      ); // this to make a copy with new course id , or use the above one
      print(
        "***************************************************************************************************************************************************** we are now afetr newCourseModel",
      );
      await docRef.set(newCourseModel.toJson());
      print(
        "***************************************************************************************************************************************************** we it must be saved now ! go check",
      );
      return Right(
        newCourseModel,
      ); // we make this for future when we want to make local data base but now just save them in firestore
    } catch (e) {
      print(
        "***************************************************************************************************************************************************** there is a problem and its ${e.toString()}",
      );
      return Left(
        ServerFailure(
          "******************************************Faild to create course : ${e.toString()}",
        ),
      );
    }
  }

  Future<Either<Failure, String>> deleteCourse(String courseId) async {
    try {
      await _firestore.collection('Courses').doc(courseId).delete();
    return Right("success deleting the course");
    } catch (e) {
      return Left(
        ServerFailure(
          "******************************************Faild to delete course : ${e.toString()}",
        ),
      );
    }
  }

  Future<Either<Failure, String>> updateCourse(CourseModel courseModel) async {
    try {
      final preData =
          await _firestore
              .collection('Courses')
              .doc(courseModel.courseId)
              .get();

      print(
        "*********************************************************************************************************************************************before fire store the updated course is${preData.data()} ",
      );
      print(
        "********************************************************************************************************************************************* course id is ${courseModel.courseId} ",
      );

      await _firestore
          .collection('Courses')
          .doc(courseModel.courseId.toString())
          .update({
            'centerId': courseModel.centerId,
            'courseId': courseModel.courseId,
            'description': courseModel.description,
            'endDate': courseModel.endDate,
            'startDate': courseModel.startDate,
            'enrolledStudents': courseModel.enrolledStudents,
            'imageUrl': courseModel.imageUrl,
            'maxStudents': courseModel.maxStudents,
            'price': courseModel.price,
            'title': courseModel.title,
            'topics': courseModel.topics,
          });
      final postData =
          await _firestore
              .collection('Courses')
              .doc(courseModel.courseId.toString())
              .get();
      print(
        "*********************************************************************************************************************************************after fire store the updated course is${postData.data()} ",
      );

      return const Right("Course update successfully");
    } catch (e) {
      return Left(ServerFailure("Faild to update course : ${e.toString()}"));
    }
  }

  Future<Either<Failure, List<CourseModel>>> getCenterCourses(
    String centerId,
  ) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('Courses')
              .where('centerId', isEqualTo: centerId)
              .get();

      print(
        "****************************************** after Firestore query, found ${querySnapshot.docs.length} courses",
      );

      if (querySnapshot.docs.isEmpty) {
        return Right([]); // لو مفيش كورسات، رجّع ليست فاضية بدل ما ترجع خطأ
      }

      final courses =
          querySnapshot.docs
              .map((doc) {
                final data = doc.data();
                print(
                  "*****************************************************************************************************************************${doc.data()}",
                );
                if (data.containsKey('centerId')) {
                  return CourseModel.fromJson(data);
                } else {
                  print(
                    "🚨 Warning: Document ${doc.id} doesn't contain centerId field!",
                  );
                  return null; // استبعاد أي بيانات ناقصة
                }
              })
              .whereType<
                CourseModel
              >() // إزالة القيم null وتحويل الليستة تلقائيًا إلى List<CourseModel>
              .toList();

      print(
        "****************************************** after converting to CourseModel, found ${courses.length} valid courses",
      );

      return Right(courses);
    } catch (e) {
      return Left(
        ServerFailure("Faild to get center courses: ${e.toString()}"),
      );
    }
  }

  Future<Either<Failure, List<StudentModel>>> getCourseStudents(
    int courseId,
  ) async {
    try {
      final courseDoc =
          await _firestore.collection('Courses').doc(courseId.toString()).get();
      if (!courseDoc.exists) {
        return Left(ServerFailure("course not found"));
      }
      final Set<String> enrolledStudents = Set<String>.from(
        courseDoc.data()?['enrolledStudents'] ?? {},
      );
      if (enrolledStudents.isEmpty) {
        return Right([]);
      }
      final studentsQuery =
          await _firestore
              .collection('Users')
              .where('role', isEqualTo: 'student')
              .where(FieldPath.documentId, whereIn: enrolledStudents.toList())
              .get();
      final students =
          studentsQuery.docs
              .map((doc) => StudentModel.fromJson(doc.data()))
              .toList();
      return Right(students);
    } catch (e) {
      return Left(
        ServerFailure("Faild to get course students : ${e.toString()}"),
      );
    }
  }
}
