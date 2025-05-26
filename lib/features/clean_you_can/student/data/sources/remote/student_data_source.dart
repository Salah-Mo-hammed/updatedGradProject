import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:grad_project_ver_1/core/errors/failure.dart';
import 'package:grad_project_ver_1/features/clean_you_can/course/data/models/course_model.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/data/models/student_model.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/domain/entities/student_entity.dart';

class WithFirebase {
  final _firestore = FirebaseFirestore.instance;

  Future<Either<Failure, StudentModel>> getStudentInfo(
    String studentId,
  ) async {
    try {
      final studentDoc =
          await _firestore
              .collection("Students")
              .doc(studentId)
              .get();
      if (!studentDoc.exists) {
        return Left(ServerFailure("no stduent with this id"));
      }
      final studentData = studentDoc.data() as Map<String, dynamic>;
      final studentInfo = StudentModel.fromJson(studentData);
      return Right(studentInfo);
    } catch (e) {
      return Left(
        ServerFailure(
          "couldnt get the info of studnet : ${e.toString()}",
        ),
      );
    }
  }

  Future<Either<Failure, void>> updateStudentInfo(
    StudentModel updatedStudent,
  ) async {
    try {
      await _firestore
          .collection("Students")
          .doc(updatedStudent.studentId)
          .update({
            'name': updatedStudent.name,
            'address': updatedStudent.address,
            'phoneNumber': updatedStudent.phoneNumber,
            'photoUrl': updatedStudent.photoUrl,
          });
      return Right(unit);
    } catch (e) {
      return Left(
        ServerFailure(
          "couldnt update the info of studnet : ${e.toString()}",
        ),
      );
    }
  }

  Future<Either<Failure, StudentEntity>> getstudentInfo(
    String studentUid,
  ) async {
    try {
      print(studentUid);
      final studentSnapshot =
          await _firestore
              .collection("Students")
              .doc(studentUid)
              .get();
      print(" done snapshot ");
      if (!studentSnapshot.exists || studentSnapshot.data() == null) {
        print(" INSIDE IF SNAPSHOT ? ");

        return Left(
          ServerFailure("there is no student with this uid"),
        );
      }
      final studentData =
          studentSnapshot.data() as Map<String, dynamic>;
      StudentModel fechedStudent = StudentModel.fromJson(studentData);
      print(" done student data ${fechedStudent.name} ");
      return Right(fechedStudent);
    } catch (e) {
      return Left(
        ServerFailure(
          "problem in student data source in getstudent Info : ${e.toString()}",
        ),
      );
    }
  }

  //! old method just wen student press enroll , it shows all courses he enrolled , without checking if status is enrolled or pendeing or any thing
  // Future<Either<Failure, Map<String, dynamic>>> getAVaialableCourses(
  //   String studentId,
  // ) async {
  //   try {
  //     // get student data first
  //     final studentSnashot =
  //         await _firestore
  //             .collection("Students")
  //             .doc(studentId)
  //             .get();
  //     if (!studentSnashot.exists) {
  //       return Left(ServerFailure("faild to reach this student"));
  //     }
  //     //fetch registredCourses IDs from the student and save it in List<String>
  //     final studentData =
  //         studentSnashot.data() as Map<String, dynamic>;
  //     // List<String> registedCourses = List<String>.from(
  //     //   studentData['registeredCourses'] ?? [],
  //     // );
  //     Map<String, dynamic> studentCourses =
  //         studentData['courses'] ?? {};
  //     List<String> registedCourses = studentCourses.keys.toList();
  //     // this just to fetch all the courses from the Courses collection
  //     final snapshot = await _firestore.collection("Courses").get();
  //     final allCourses =
  //         snapshot.docs.map((doc) {
  //           return CourseModel.fromJson(doc.data());
  //         }).toList();
  //     final filteredCourses =
  //         allCourses
  //             .where(
  //               (course) => registedCourses.contains(course.courseId),
  //             )
  //             .toList();
  //     Map<String, dynamic> allAndFilteredCourses = {
  //       'allCourses': allCourses,
  //       'filteredCourses': filteredCourses,
  //     };
  //     return Right(allAndFilteredCourses);
  //   } catch (e) {
  //     return Left(
  //       ServerFailure(
  //         "Faild to fetch courses because:  ${e.toString()}",
  //       ),
  //     );
  //   }
  // }

  Future<Either<Failure, Map<String, dynamic>>> getAVaialableCourses(
    String studentId,
  ) async {
    try {
      // Get student data
      final studentSnapshot =
          await _firestore
              .collection("Students")
              .doc(studentId)
              .get();

      if (!studentSnapshot.exists) {
        return Left(ServerFailure("Failed to reach this student"));
      }

      final studentData =
          studentSnapshot.data() as Map<String, dynamic>;
      final Map<String, dynamic> studentCourses =
          studentData['courses'] ?? {};

      // Get the list of courseIds where status == "enrolled"
      final List<String> enrolledCourseIds =
          studentCourses.entries
              .where(
                (entry) =>
                    entry.value is Map &&
                    (entry.value['status'] ?? '') == 'enrolled',
              )
              .map((entry) => entry.key)
              .toList();

      // Fetch all courses
      final snapshot = await _firestore.collection("Courses").get();
      final allCourses =
          snapshot.docs
              .map((doc) => CourseModel.fromJson(doc.data()))
              .toList();

      // Filter courses that are "enrolled" only
      final filteredCourses =
          allCourses
              .where(
                (course) =>
                    enrolledCourseIds.contains(course.courseId),
              )
              .toList();

      final result = {
        'allCourses': allCourses,
        'filteredCourses': filteredCourses,
      };

      return Right(result);
    } catch (e) {
      return Left(
        ServerFailure(
          "Failed to fetch courses because: ${e.toString()}",
        ),
      );
    }
  }

  Future<Either<Failure, Unit>> enrollInCourse(
    String centerId,
    String studentUid,
    String courseId,
    String proofImageUrl,
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
        // final studentData = studentSnap.data()!;
        final courseData = courseSnap.data()!;
        // we make them in List for registedCourses and Set for enrolled students
        // final List<String> registeredCourses = List<String>.from(
        //   studentData['registeredCourses'] ?? [],8
        // );
        final Set<String> enrolledStudents = Set<String>.from(
          courseData['enrolledStudents'] ?? [],
        );

        // check if the courseId isnt previously exsist in the registedCourses
        // so we added it
        // if (!registeredCourses.contains(courseId)) {
        //   registeredCourses.add(courseId);8
        // }

        // checks if the student isnt previously exsist in the registedCourses
        // so we added it
        if (!enrolledStudents.contains(studentUid)) {
          enrolledStudents.add(studentUid);
        }
        // here we update the data in firebase ,
        // note the deffeirenses between  registeredCourses.add(courseId); and 'registeredCourses': registeredCourses,
        // is the first one add it to the value and the second we send the value to firestore
        // transaction.update(studentRef, {
        //   'registeredCourses': registeredCourses,8
        // });
        transaction.update(studentRef, {
          'courses.$courseId': {
            'courseId': courseId,
            'status':
                'pending', //! if payment with electirc gateway, make this enrolled , if bank transfare then pending
            'progress': 0,
            'assignments': {},
            'result': null,
          },
        });
        transaction.update(courseRef, {
          'enrolledStudents': enrolledStudents.toList(),
        });
      });
      //! uncomment send request when you pay to firebase storage
      //  await sendRequest(studentId: studentUid, centerId: centerId, courseId: courseId, proofImageUrl: proofImageUrl);
      return Right(unit);
    } catch (e) {
      return Left(ServerFailure("Failed to enroll: ${e.toString()}"));
    }
  }

  Future<void> sendRequest({
    required String studentId,
    required String centerId,
    required String courseId,
    required String proofImageUrl,
  }) async {
    final requestRef =
        _firestore.collection('course_enroll_requests').doc();
    final studentSnap =
        await _firestore.collection('Students').doc(studentId).get();

    final studentData = studentSnap.data()!;
    final String studentName = studentData['fullName'] ?? '';
    final String studentPhone = studentData['phone'] ?? '';

    await requestRef.set({
      'requestId': requestRef.id,
      'studentId': studentId,
      'studentName': studentName,
      'studentPhone': studentPhone,
      'centerId': centerId,
      'courseId': courseId,
      'proofImageUrl': proofImageUrl,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
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

      // ignore: avoid_print
      print(
        "*************************done creating student and adding to firestore",
      );
      // ignore: void_checks
      return Right(unit);
    } on FirebaseException catch (e) {
      return Left(DatabaseFailure(e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
