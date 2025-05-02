import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad_project_ver_1/features/clean_you_can/course/domain/entities/Course-entity.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/presentation/bloc/student_bloc.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/presentation/bloc/student_event.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/presentation/bloc/student_state.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/presentation/widgets/common_widgets.dart';

class ShowAvailableCoursesWidget extends StatefulWidget {
  final String studentId;
  const ShowAvailableCoursesWidget({
    super.key,
    required this.studentId,
  });

  @override
  State<ShowAvailableCoursesWidget> createState() =>
      _ShowAvailableCoursesWidgetState();
}

class _ShowAvailableCoursesWidgetState
    extends State<ShowAvailableCoursesWidget> {
  int _selectedButton = -1;
  List<String> categories = [
    "Technology",
    " Language",
    " Buisness",
    "Health",
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CommonWidgets().buildHeaderText(
              "Available Courses",
              true,
            ),
          ),
          SliverToBoxAdapter(
            child: CommonWidgets().buildSubTitleText(
              "Explore courses to enhance your skills",
            ),
          ),
          //! categories buttons
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(4, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 3,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        backgroundColor:
                            _selectedButton == index
                                ? Colors.black
                                : Colors.grey[100],
                        foregroundColor:
                            _selectedButton == index
                                ? Colors.white
                                : Colors.grey[700],
                      ),
                      onPressed: () {
                        setState(() {
                          if (_selectedButton == index) {
                            _selectedButton = -1;
                          } else
                            _selectedButton = index;
                        });
                      },
                      child: Text(categories[index]),
                    ),
                  );
                }),
              ),
            ),
          ),
          //! stack for featured course image
          SliverToBoxAdapter(
            child: CommonWidgets().buildStack(false),
          ),
          //! recent courses row
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonWidgets().buildHeaderText(
                  "Recent Courses",
                  true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  child: Text(
                    "View All",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.blue[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
          //!  List of Cards
          BlocBuilder<StudentBloc, StudentState>(
            builder: (context, state) {
              if (state is StudentGotAvailableAndHisCoursesState) {
                final allCourses = state.allCourses;
                List<CourseEntity> availableCourses = allCourses['allCourses'];
                List<CourseEntity> filteredCourses = allCourses['filteredCourses'];
                return SliverList(
                  delegate: SliverChildBuilderDelegate((
                    context,
                    index,
                  ) {

                    return CommonWidgets().buildCourseCard(
                      widget.studentId,
                      availableCourses,
                      index,
                      false,
                      context,
                    );
                  }, childCount: availableCourses.length),
                );
              } else if (state is StudentExceptionState) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text(state.message.toString()),
                  ),
                );
              } else {
                context.read<StudentBloc>().add(
                  GetAvailableAndMineCoursesEvent(
                    studentId: widget.studentId,
                  ),
                );

                return SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
