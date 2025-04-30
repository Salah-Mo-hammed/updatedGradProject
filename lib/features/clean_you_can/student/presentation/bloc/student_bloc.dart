import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/domain/usecases/creat_student_usecase.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/domain/usecases/get_available_courses_usecase.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/presentation/bloc/student_event.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/presentation/bloc/student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final CreatStudentUsecase creatStudentUsecase;
  final GetAvailableCoursesUsecase getAvailableCoursesUsecase;
  StudentBloc({
    required this.creatStudentUsecase,
    required this.getAvailableCoursesUsecase,
  }) : super(const StudentInitialState()) {
    on<CreateStudentEvent>(onCreateStudent);
    on<GetAvailableCoursesEvent>(onGetAvailableCourses);
  }

  FutureOr<void> onCreateStudent(
    CreateStudentEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoadingState());
    final result = await creatStudentUsecase.call(
      event.createStudent,
    );
    result.fold(
      (failure) {
        emit(StudentExceptionState(message: failure.message));
      },
      (unit) {
        emit(StudentCreatedState());
      },
    );
  }

  FutureOr<void> onGetAvailableCourses(
    GetAvailableCoursesEvent event,
    Emitter<StudentState> emit,
  ) async{
    emit(StudentLoadingState());
    final result=await getAvailableCoursesUsecase.call();

    result.fold((failure)=> emit(StudentExceptionState(message: failure.message)), (availableCourses)=> emit(StudentGotAvailableCoursesState(availableCourses: availableCourses)));
  }
}
