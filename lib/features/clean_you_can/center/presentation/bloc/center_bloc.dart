import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/usecases/create_centerusecase.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/usecases/create_course_usecase.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/usecases/delete_course_usecase.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/usecases/get_center_courses_usecase.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/usecases/update_course_usecase.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/presentation/bloc/center_event.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/presentation/bloc/center_state.dart';

class CenterBloc extends Bloc<CenterEvent, CenterState> {
  CreateCenterusecase createCenterusecase;
  AddCourseUsecase addCourseUsecase;
  UpdateCourseUsecase updateCourseUsecase;
  GetCenterCoursesUsecase getCenterCoursesUsecase;
  DeleteCourseUsecase deleteCourseUsecase;
  CenterBloc({
    required this.deleteCourseUsecase,
    required this.updateCourseUsecase,
    required this.createCenterusecase,
    required this.addCourseUsecase,
    required this.getCenterCoursesUsecase,
  }) : super(const CenterInitialState()) {
    on<CreateCenterEvent>(onCreateCenter);
    on<AddCourseEvent>(onAddCourse);
    on<GetCenterCoursesEvent>(onGetCenterCourses);
    on<UpdateCourseEvent>(onUpdateCourse);
    on<DeleteCourseEvent>(onDeleteCourse);
  }

  FutureOr<void> onCreateCenter(
    CreateCenterEvent event,
    Emitter<CenterState> emit,
  ) async {
    emit(CenterLoadingState());
    final result = await createCenterusecase.call(event.createCenter);
    result.fold(
      (failure) {
        emit(CenterExceptionState(message: failure.message));
      },
      (unit) {
        emit(CenterCreatedState());
      },
    );
  }

  FutureOr<void> onAddCourse(
    AddCourseEvent event,
    Emitter<CenterState> emit,
  ) async {
    emit(CenterLoadingState());
    final result = await addCourseUsecase.call(event.addCourseEntity);
    result.fold(
      (failure) {
        emit(CenterExceptionState(message: failure));
      },
      (course) {
        emit(CenterAddedCourseState(courseEntity: course));
      },
    );
  }

  FutureOr<void> onGetCenterCourses(
    GetCenterCoursesEvent event,
    Emitter<CenterState> emit,
  ) async {
    emit(CenterLoadingState());

    final result = await getCenterCoursesUsecase.call(event.centerId);
    result.fold(
      (failure) {
        emit(CenterExceptionState(message: failure.message));
      },
      (courses) {
        emit(CenterGotCoursesState(courses: courses));
      },
    );
  }

  FutureOr<void> onUpdateCourse(
    UpdateCourseEvent event,
    Emitter<CenterState> emit,
  ) async {
    emit(CenterLoadingState());
    final result = await updateCourseUsecase.call(event.updateCourseEntity);
    result.fold(
      (failure) {
        emit(CenterExceptionState(message: failure.message));
      },
      (successMessage) {
        emit(CenterUpdatedCourseState());
      },
    );
  }

  FutureOr<void> onDeleteCourse(
    DeleteCourseEvent event,
    Emitter<CenterState> emit,
  ) async {
    emit(CenterLoadingState());
    final result = await deleteCourseUsecase.call(event.courseId);
    result.fold(
      (failure) {
        emit(CenterExceptionState(message: failure.message));
      },
      (success) {
        emit(CenterInitialState());
      },
    );
  }
}
