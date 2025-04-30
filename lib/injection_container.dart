import 'package:dio/dio.dart';

import 'package:get_it/get_it.dart';
import 'package:grad_project_ver_1/features/auth/data/source/remote/auth_data_source.dart';
import 'package:grad_project_ver_1/features/auth/data/repo_impl/repo_impl.dart';
import 'package:grad_project_ver_1/features/auth/domain/repo/auth_repo.dart';
import 'package:grad_project_ver_1/features/auth/domain/usecases/forget_pass_usecase.dart';
import 'package:grad_project_ver_1/features/auth/domain/usecases/get_auth_usecase.dart.dart';
import 'package:grad_project_ver_1/features/auth/domain/usecases/login_usecase.dart';
import 'package:grad_project_ver_1/features/auth/domain/usecases/logout_usecase.dart';
import 'package:grad_project_ver_1/features/auth/domain/usecases/register_usecase.dart';
import 'package:grad_project_ver_1/features/auth/presintation/bloc/auth_bloc.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/data/repo_impl/center_repo_impl.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/data/sources/remote/center_data_source.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/repo/center_repo.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/usecases/create_centerusecase.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/usecases/create_course_usecase.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/usecases/delete_course_usecase.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/usecases/get_center_courses_usecase.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/usecases/get_course_students.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/domain/usecases/update_course_usecase.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/presentation/bloc/center_bloc.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/data/repo_impl/stu_repo_impl.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/data/sources/remote/student_data_source.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/domain/repo/student_repo.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/domain/usecases/creat_student_usecase.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/domain/usecases/get_available_courses_usecase.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/presentation/bloc/student_bloc.dart';

GetIt sl = GetIt.instance;
Future<void> initialaizedDependencies() async {
  //! Note: you must do it with  this arrangement : http request or Dio => data-dataSource => repo (<repo from domain>(repoimple)) =>

  //! domain-usecases => blocs
  sl.registerSingleton<Dio>(Dio());
  //! data-dataSource
  sl.registerSingleton<AuthDataSource>(AuthDataSource());
  sl.registerSingleton<StudentDataSource>(StudentDataSource());
  sl.registerSingleton<CenterDataSource>(CenterDataSource());

  //! domain-repo
  sl.registerSingleton<AuthRepo>(
    AuthRepoImpl(authDataSource: sl<AuthDataSource>()),
  );
  sl.registerSingleton<StudentRepo>(
    StudentRepoImpl(studentDataSource: sl<StudentDataSource>()),
  );
  sl.registerSingleton<CenterRepo>(
    CenterRepoImpl(
      authDataSource: sl<AuthDataSource>(),
      centerDataSource: sl<CenterDataSource>(),
    ),
  );
  //! domain-usecases

  sl.registerSingleton<LogInUsecase>(
    LogInUsecase(repo: sl<AuthRepo>()),
  );
  sl.registerSingleton<LogOutUsecase>(
    LogOutUsecase(repo: sl<AuthRepo>()),
  );
  sl.registerSingleton<RegisterUsecase>(
    RegisterUsecase(repo: sl<AuthRepo>()),
  );

  sl.registerSingleton<GetAuthStatusUseCase>(
    GetAuthStatusUseCase(repo: sl<AuthRepo>()),
  );
  sl.registerSingleton<ForgetPassUsecase>(
    ForgetPassUsecase(repo: sl<AuthRepo>()),
  );

  sl.registerSingleton<CreatStudentUsecase>(
    CreatStudentUsecase(studentRepo: sl<StudentRepo>()),
  );

  sl.registerSingleton<CreateCenterusecase>(
    CreateCenterusecase(centerRepo: sl<CenterRepo>()),
  );

  sl.registerSingleton<AddCourseUsecase>(
    AddCourseUsecase(centerRepo: sl<CenterRepo>()),
  );
  sl.registerSingleton<DeleteCourseUsecase>(
    DeleteCourseUsecase(centerRepo: sl<CenterRepo>()),
  );
  sl.registerSingleton<UpdateCourseUsecase>(
    UpdateCourseUsecase(centerRepo: sl<CenterRepo>()),
  );
  sl.registerSingleton<GetCenterCoursesUsecase>(
    GetCenterCoursesUsecase(centerRepo: sl<CenterRepo>()),
  );
  sl.registerSingleton<GetCourseStudents>(
    GetCourseStudents(centerRepo: sl<CenterRepo>()),
  );
  sl.registerSingleton<GetAvailableCoursesUsecase>(
    GetAvailableCoursesUsecase(studentRepo: sl<StudentRepo>()),
  );
  //! blocs

  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      logInUsecase: sl<LogInUsecase>(),
      logOutUsecase: sl<LogOutUsecase>(),
      registerUsecase: sl<RegisterUsecase>(),
      getAuthStatusUseCase: sl<GetAuthStatusUseCase>(),
      resetPassUseCase: sl<ForgetPassUsecase>(),
    ),
  );
  sl.registerFactory(
    () => StudentBloc(
      creatStudentUsecase: sl<CreatStudentUsecase>(),
      getAvailableCoursesUsecase: sl<GetAvailableCoursesUsecase>(),
    ),
  );
  sl.registerFactory(
    () => CenterBloc(
      createCenterusecase: sl<CreateCenterusecase>(),
      addCourseUsecase: sl<AddCourseUsecase>(),
      getCenterCoursesUsecase: sl<GetCenterCoursesUsecase>(),
      updateCourseUsecase: sl<UpdateCourseUsecase>(),
      deleteCourseUsecase: sl<DeleteCourseUsecase>(),
    ),
  );
}
