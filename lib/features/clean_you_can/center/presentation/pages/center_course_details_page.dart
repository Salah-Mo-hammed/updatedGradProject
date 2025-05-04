import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/presentation/blocs/center_courses_bloc/center_courses_bloc.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/presentation/blocs/center_trainer_bloc/center_bloc.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/presentation/blocs/center_trainer_bloc/center_event.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/presentation/pages/edit_course_page.dart';
import 'package:grad_project_ver_1/features/clean_you_can/course/domain/entities/course_entity.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/presentation/pages/confirm_enrollment_page.dart';

class CourseDetailsPage extends StatelessWidget {
  final bool isStudent;
  final String? studentId;
  final CourseEntity course;

  const CourseDetailsPage({
    super.key,
    required this.course,
    required this.isStudent,
    this.studentId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          course.title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        actions: [
          if (isStudent) ...[
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () {
                context.read<CenterCoursesBloc>().add(
                  DeleteCourseEvent(courseId: course.courseId),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => EditCoursePage(course: course),
                  ),
                );
              },
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  //! here go to confirm enrollmet page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ConfirmEnrollmentPage(
                            currentStudentId: studentId!,
                            selcetedCourse: course,
                          ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Text(
                    " Enroll ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (course.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  course.imageUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),

            _buildTitle(course.title),
            _buildDescription(course.description),
            const SizedBox(height: 16),

            _buildInfoCard(
              Icons.monetization_on,
              "Price",
              "\$${course.price.toStringAsFixed(2)}",
            ),
            _buildInfoCard(
              Icons.people,
              "Max Students",
              "${course.maxStudents}",
            ),
            _buildInfoCard(
              Icons.calendar_today,
              "Start Date",
              _formatDate(course.startDate),
            ),
            _buildInfoCard(
              Icons.event,
              "End Date",
              _formatDate(course.endDate),
            ),
            _buildInfoCard(
              Icons.person,
              "Enrolled Students",
              "${course.enrolledStudents.length}",
            ),

            const SizedBox(height: 16),
            _buildTopicsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildDescription(String description) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        description,
        style: const TextStyle(fontSize: 18, color: Colors.black54),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.blueGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildTopicsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Topics:",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        course.topics.isNotEmpty
            ? Column(
              children:
                  course.topics.map((topic) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        title: Text(
                          topic,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            )
            : const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "No topics added for now",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Not specified";
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
