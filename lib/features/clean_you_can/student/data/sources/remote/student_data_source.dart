import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:grad_project_ver_1/core/errors/failure.dart';
import 'package:grad_project_ver_1/features/clean_you_can/course/data/models/course_model.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/data/models/student_model.dart';

class StudentDataSource {
  final _firestore = FirebaseFirestore.instance;

  Future<Either<Failure, List<CourseModel>>> getAVaialableCourses()async{
try {
 final snapshot= await _firestore.collection("Courses").get();
final courses=snapshot.docs.map((doc){
  return CourseModel.fromJson(doc.data());
}).toList();

return Right(courses);
} catch (e) {
  return Left(ServerFailure("Faild to fetch courses because:  ${e.toString()}"));
  
}

  }
  Future<Either<Failure, void>> createStudent(StudentModel newStudent) async {
    try {
      await _firestore
          .collection('Students')
          .doc(newStudent.studentId)
          .set(newStudent.toJson());
      await _firestore.collection("Users").doc(newStudent.studentId).update({
        'isCompletedInfo': true,
      });
      
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
