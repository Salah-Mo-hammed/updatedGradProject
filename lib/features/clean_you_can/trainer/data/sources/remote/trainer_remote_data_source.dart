import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grad_project_ver_1/core/errors/failure.dart';
import 'package:grad_project_ver_1/features/clean_you_can/trainer/data/models/trainer_model.dart';

class TrainerRemoteDataSource {
  final  _firebaseAuth=FirebaseAuth.instance;
  final  _firestore=FirebaseFirestore.instance;


  Future<Either<Failure, String>> createTrainer(TrainerModel newTrainer) async {
    try {
      // Create user with email and password in Firebase Authentication
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: newTrainer.email,
        password: newTrainer.password,
      );

      // Get the generated UID
      String generetedId = userCredential.user!.uid;

      // Save trainer info in Firestore under the "Trainers" collection
      await _firestore.collection('Trainers').doc(generetedId).set(newTrainer.toJson(generetedId));

      return Right(generetedId);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure( "${e.code}: ${e.message} from trainer FirebaseAuthException"));
    } on FirebaseException catch (e) {
      return Left(AuthFailure( "${e.code}: ${e.message} from trainer FirebaseException"));
    } catch (e) {
      return Left(AuthFailure( 'An unexpected error occurred from trainer: $e'));
    }
  }


}