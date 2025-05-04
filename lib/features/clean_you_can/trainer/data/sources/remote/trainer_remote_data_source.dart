// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dartz/dartz.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:grad_project_ver_1/core/errors/failure.dart';
// import 'package:grad_project_ver_1/features/clean_you_can/trainer/data/models/trainer_model.dart';
// import 'package:grad_project_ver_1/features/clean_you_can/trainer/domain/entities/trainer_entity.dart';

// class TrainerRemoteDataSource {
//   final  _firebaseAuth=FirebaseAuth.instance;
//   final  _firestore=FirebaseFirestore.instance;

//   Future<Either<Failure, List<TrainerEntity>>> fetchCenterTrainers(
//     String centerId,
//   ) async {
//     try {
//       final querySnapshot =
//           await _firestore
//               .collection('Trainers')
//               .where('centerId', isEqualTo: centerId)
//               .get();

//       if (querySnapshot.docs.isEmpty) {
//         return Right(
//           [],
//         ); // لو مفيش مدربين، رجّع ليست فاضية بدل ما ترجع خطأ
//       }

//       final trainers =
//           querySnapshot.docs
//               .map((doc) {
//                 final data = doc.data();

//                 if (data.containsKey('centerId')) {
//                   return TrainerModel.fromJson(data);
//                 } else {
//                   return null; // استبعاد أي بيانات ناقصة
//                 }
//               })
//               .whereType<
//                 TrainerModel
//               >() // إزالة القيم null وتحويل الليستة تلقائيًا إلى List<TrainerModel>
//               .toList();

//       return Right(trainers);
//     } catch (e) {
//       return Left(
//         ServerFailure("Faild to get trainers: ${e.toString()}"),
//       );
//     }
//   }
 


// }