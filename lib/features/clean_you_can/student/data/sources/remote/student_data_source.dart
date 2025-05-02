import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:grad_project_ver_1/core/errors/failure.dart';
import 'package:grad_project_ver_1/features/clean_you_can/course/data/models/course_model.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/data/models/student_model.dart';

class WithFirebase {
  final _firestore = FirebaseFirestore.instance;

  Future<Either<Failure, Map<String, dynamic>>> getAVaialableCourses(
    String studentId,
  ) async {
    try {
      // get student data first
      final studentSnashot =
          await _firestore
              .collection("Students")
              .doc(studentId)
              .get();
      if (!studentSnashot.exists) {
        return Left(ServerFailure("faild to reach this student"));
      }
      //fetch registredCourses IDs from the student and save it in List<String>
      final studentData =
          studentSnashot.data() as Map<String, dynamic>;
      List<String> registedCourses = List<String>.from(
        studentData['registeredCourses'] ?? [],
      );
      // this just to fetch all the courses from the Courses collection
      final snapshot = await _firestore.collection("Courses").get();
      final allCourses =
          snapshot.docs.map((doc) {
            return CourseModel.fromJson(doc.data());
          }).toList();
      final filteredCourses =
          allCourses
              .where(
                (course) => registedCourses.contains(course.courseId),
              )
              .toList();
      Map<String, dynamic> allAndFilteredCourses = {
        'allCourses': allCourses,
        'filteredCourses': filteredCourses,
      };
      return Right(allAndFilteredCourses);
    } catch (e) {
      return Left(
        ServerFailure(
          "Faild to fetch courses because:  ${e.toString()}",
        ),
      );
    }
  }

  Future<Either<Failure, Unit>> enrollInCourse(
    String studentUid,
    String courseId,
  ) async {
    try {
      // references for student and course

      final studentRef = _firestore
          .collection('Students')
          .doc(studentUid);
      final courseRef = _firestore
          .collection('Courses')
          .doc(courseId);

      await _firestore.runTransaction((transaction) async {
        // run transiction becuase there wil be 2 updates in the registred courses and enrolledstudents
        // transiction
        final studentSnap = await transaction.get(studentRef);
        final courseSnap = await transaction.get(courseRef);
        //check if there is no student then throw exception
        if (!studentSnap.exists) {
          throw Exception("Student not found");
        }
        //check if there is no course then throw exception

        if (!courseSnap.exists) {
          throw Exception("Course not found");
        }
        // if we arrive here , that means there is data (there is student and course)
        //so we get the data  under this comment
        final studentData = studentSnap.data()!;
        final courseData = courseSnap.data()!;
        // we make them in List for registedCourses and Set for enrolled students
        final List<String> registeredCourses = List<String>.from(
          studentData['registeredCourses'] ?? [],
        );
        final Set<String> enrolledStudents = Set<String>.from(
          courseData['enrolledStudents'] ?? [],
        );

        // check if the courseId isnt previously exsist in the registedCourses
        // so we added it
        if (!registeredCourses.contains(courseId)) {
          registeredCourses.add(courseId);
        }

        // checks if the student isnt previously exsist in the registedCourses
        // so we added it
        if (!enrolledStudents.contains(studentUid)) {
          enrolledStudents.add(studentUid);
        }
        // here we update the data in firebase ,
        // note the deffeirenses between  registeredCourses.add(courseId); and 'registeredCourses': registeredCourses,
        // is the first one add it to the value and the second we send the value to firestore
        transaction.update(studentRef, {
          'registeredCourses': registeredCourses,
        });

        transaction.update(courseRef, {
          'enrolledStudents': enrolledStudents.toList(),
        });
      });

      return Right(unit);
    } catch (e) {
      return Left(ServerFailure("Failed to enroll: ${e.toString()}"));
    }
  }

  Future<Either<Failure, void>> createStudent(
    StudentModel newStudent,
  ) async {
    try {
      await _firestore
          .collection('Students')
          .doc(newStudent.studentId)
          .set(newStudent.toJson());
      await _firestore
          .collection("Users")
          .doc(newStudent.studentId)
          .update({'isCompletedInfo': true});

      print(
        "*************************done creating student and adding to firestore",
      );
      return Right(unit);
    } on FirebaseException catch (e) {
      return Left(DatabaseFailure(e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
