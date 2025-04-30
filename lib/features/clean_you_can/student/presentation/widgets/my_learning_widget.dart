import 'package:flutter/material.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/presentation/widgets/common_widgets.dart';

class MyLearningWidget extends StatelessWidget {
  const MyLearningWidget({super.key});

  @override
  Widget build(BuildContext context) {
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

          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return CommonWidgets().buildCourseCard(
                [],
                index,
                true,
                context,
              );
            }, childCount: 2),
          ),
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
            delegate: SliverChildBuilderDelegate((context, index) {
              return CommonWidgets().buildCourseCard(
                [],
                index,
                true,
                context,
              );
            }, childCount: 5),
          ),
        ],
      ),
    );
  }
}
