import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad_project_ver_1/features/clean_you_can/course/domain/entities/Course-entity.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/presentation/bloc/student_bloc.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/presentation/widgets/common_widgets.dart';

class MyLearningWidget extends StatelessWidget {
  final String studentId;

  const MyLearningWidget({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    List<CourseEntity> filteredCourses =
        context
            .read<StudentBloc>()
            .state
            .availableCourses!['filteredCourses'];
    print(
      "*-*-*/-*/-/*-/-*-*-*/-*/-*-*-*--*- ${filteredCourses} before go to in progress",
    );
    return Expanded(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CommonWidgets().buildHeaderText(
              "My Courses",
              true,
            ),
          ),
          SliverToBoxAdapter(
            child: CommonWidgets().buildSubTitleText(
              "Track your progress and continue learning",
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: CommonWidgets().buildHeaderText(
                "Completed",
                false,
              ),
            ),
          ),

          // SliverList(
          //   delegate: SliverChildBuilderDelegate((context, index) {
          //     return CommonWidgets().buildCourseCard(
          //       studentId,
          //       filteredCourses,
          //       index,
          //       true,
          //       context,
          //     );
          //   }, childCount: filteredCourses.length),
          // ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: CommonWidgets().buildHeaderText(
                "In Progress",
                false,
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return CommonWidgets().buildCourseCard(
                  studentId,
                  filteredCourses.isEmpty
                      ? [
                        CourseEntity(
                          courseId: "courseId",
                          title: " title",
                          description: "description",
                          centerId: "centerId",
                          startDate: DateTime.now(),
                          endDate: DateTime.now(),
                          maxStudents: 55,
                          price: 98,
                        ),
                      ]
                      : filteredCourses,
                  index,
                  true,
                  context,
                );
              },
              childCount:
                  filteredCourses.isEmpty
                      ? 1
                      : filteredCourses.length,
            ),
          ),
        ],
      ),
    );
  }
}
