

abstract class StudentState {
   final Map<String,dynamic>? availableCourses;

  const StudentState({this.availableCourses});
}

class StudentInitialState extends StudentState {
  const StudentInitialState();
}

class StudentLoadingState extends StudentState {}

class StudentCreatedState extends StudentState {}

class StudentRefreshState extends StudentState {}

class StudentExceptionState extends StudentState {
  // ignore: prefer_typing_uninitialized_variables
  final message;
  StudentExceptionState({required this.message});
}

class StudentGotAvailableAndHisCoursesState extends StudentState {
  Map<String,dynamic> allCourses;
  StudentGotAvailableAndHisCoursesState({
    required this.allCourses,
  }):super(availableCourses: allCourses);
}

