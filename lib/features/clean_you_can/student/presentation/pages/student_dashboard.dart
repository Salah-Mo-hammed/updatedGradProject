import 'package:flutter/material.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/presentation/widgets/certificates_widget.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/presentation/widgets/my_learning_widget.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/presentation/widgets/notifications_widget.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/presentation/widgets/show_available_courses.dart';

// ignore: must_be_immutable
class StudentDashboard extends StatefulWidget {
  String currentStudentId;
   StudentDashboard({super.key, required this.currentStudentId});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();


}

class _StudentDashboardState extends State<StudentDashboard> {
  
  int _selectedIndex = 0;
  bool _isSearchExpanded = false;

  void _onTapBottomBar(int tempIndex) {
    setState(() {
      _selectedIndex = tempIndex;
    });
  }

  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return ShowAvailableCoursesWidget(studentId:widget.currentStudentId);
      case 1:
        return MyLearningWidget(studentId: widget.currentStudentId,);
      case 2:
        return CertificatesWidget();
      case 3:
        return NotificationsWidget();
      default:
        return ShowAvailableCoursesWidget(studentId:widget.currentStudentId);
    }
  }
  @override
  void initState() {
    //!get the student from the firestore 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      print("**************************************************************-------------------------**************-------------------****************** this is studnet id in student Dashboard ${widget.currentStudentId}");
    
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              elevation: 2,
              child: Row(
                children: [
                  // User Info
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.orange,
                          child: Icon(Icons.person_off_outlined),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Salah Mohammed",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "Intermediate Level",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Spacer(),

                  // Search bar
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isSearchExpanded = !_isSearchExpanded;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          height: 50,
                          width: _isSearchExpanded ? 220 : 50,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              AnimatedCrossFade(
                                duration: Duration(milliseconds: 200),
                                firstChild: Icon(Icons.search),
                                secondChild: Icon(
                                  Icons.arrow_forward_ios,
                                ),
                                crossFadeState:
                                    !_isSearchExpanded
                                        ? CrossFadeState.showFirst
                                        : CrossFadeState.showSecond,
                              ),
                              if (_isSearchExpanded) ...[
                                SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "search courses...",
                                      hintStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Selected Page
          _getSelectedPage(_selectedIndex),
        ],
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTapBottomBar,
        selectedItemColor: Colors.deepPurple[500],
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            label: "Courses",
            icon: Icon(Icons.menu_book_rounded),
          ),
          BottomNavigationBarItem(
            label: "My Learning",
            icon: Icon(Icons.bookmark_border),
          ),
          BottomNavigationBarItem(
            label: "Certificates",
            icon: Icon(Icons.done_outline_rounded),
          ),
          BottomNavigationBarItem(
            label: "Notifications",
            icon: Icon(Icons.notifications_none),
          ),
        ],
      ),
    );
  }
}
