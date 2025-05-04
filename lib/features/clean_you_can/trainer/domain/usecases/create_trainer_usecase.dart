import 'package:dartz/dartz.dart';
import 'package:grad_project_ver_1/core/errors/failure.dart';
import 'package:grad_project_ver_1/features/clean_you_can/trainer/domain/entities/trainer_entity.dart';
import 'package:grad_project_ver_1/features/clean_you_can/trainer/domain/repo/trianer_repo.dart';

class CreateTrainerUsecase {
  TrianerRepo trianerRepo;
  CreateTrainerUsecase({required this.trianerRepo});
  Future<Either<Failure,String>> call(TrainerEntity newTrainer)  {
   return trianerRepo.createTrainer(newTrainer);
  }
}