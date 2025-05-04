import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/entities/center_entity.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/usecases/create_centerusecase.dart';

part 'center_general_event.dart';
part 'center_general_state.dart';

class CenterGeneralBloc extends Bloc<CenterGeneralEvent, CenterGeneralState> {
    CreateCenterusecase createCenterusecase;
  CenterGeneralBloc({required this.createCenterusecase}) : super(CenterGeneralInitial()) {
    on<CreateCenterEvent>(onCreateCenter);
  }

 FutureOr<void> onCreateCenter(
    CreateCenterEvent event,
    Emitter<CenterGeneralState> emit,
  ) async {
    emit(CenterGeneralLoadingState());
    final result = await createCenterusecase.call(event.createCenter);
    result.fold(
      (failure) {
        emit(CenterGeneralExceptionState(message: failure.message));
      },
      (unit) {
        emit(CenterGeneralCreatedState());
      },
    );
  }

}
