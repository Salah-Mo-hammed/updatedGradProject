import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grad_project_ver_1/features/clean_you_can/trainer/domain/entities/trainer_entity.dart';
import 'package:grad_project_ver_1/features/clean_you_can/trainer/domain/usecases/create_trainer_usecase.dart';

part 'trainer_event.dart';
part 'trainer_state.dart';

class TrainerBloc extends Bloc<TrainerEvent, TrainerState> {
  CreateTrainerUsecase createTrainerUsecase;
  TrainerBloc({required this.createTrainerUsecase})
    : super(TrainerLoadingState()) {
    on<CreateTrainerEvent>(onCreateTrainer);
  }

  FutureOr<void> onCreateTrainer(
    CreateTrainerEvent event,
    Emitter<TrainerState> emit,
  ) async {
    final result = await createTrainerUsecase(event.newTrainer);
    result.fold(
      (failure) {
        emit(TrainerExceptionState(errorMessage: failure.message));
      },
      (uid) {
        emit(TrainerCreatedState(trainerUid: uid));
      },
    );
  }
}
