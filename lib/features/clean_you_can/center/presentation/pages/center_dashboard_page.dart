import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:grad_project_ver_1/core/colors/app_color.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/presentation/bloc/center_bloc.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/presentation/bloc/center_event.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/presentation/bloc/center_state.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/presentation/pages/add_course_page.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/presentation/pages/center_course_details_page.dart';

class CenterDashboard extends StatefulWidget {
  final String centerId;
  const CenterDashboard({super.key, required this.centerId});

  @override
  _CenterDashboardState createState() => _CenterDashboardState();
}

class _CenterDashboardState extends State<CenterDashboard> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    //!get the center from the firestore 
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // Gradient background using your gold/bronze tones
    return Scaffold(
      appBar: AppBar(
        title: FadeInDown(
          duration: Duration(milliseconds: 700),
          child: Text(
            "Center Dashboard",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.darkGray,
              fontSize: 22,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 9,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gold, AppColors.bronze],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.brown),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF7EEDD), // pastel beige (matches gold)
              Color(0xFFFDF6EE), // lighter peach
              Colors.white,
            ],
          ),
        ),
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildCoursesPage(),
            _buildChatChannelPage(),
            _buildProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gold.withOpacity(0.18), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.bronze.withOpacity(0.09),
              blurRadius: 16,
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Courses',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.bronze,
          unselectedItemColor: AppColors.silverGray,
          onTap: _onItemTapped,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
      floatingActionButton: FadeInUp(
        duration: const Duration(milliseconds: 420),
        child: FloatingActionButton(
          backgroundColor: AppColors.bronze,
          elevation: 7,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        AddCoursePage(centerId: widget.centerId),
              ),
            );
          },
          child: const Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildCoursesPage() {
    return FadeIn(
      duration: const Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              duration: const Duration(milliseconds: 650),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 8,
                color: AppColors.gold.withOpacity(0.14),
                shadowColor: AppColors.brown.withOpacity(0.17),
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Courses",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: AppColors.brown,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        "Manage your courses efficiently!",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.mediumGray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Expanded(
              child: BlocBuilder<CenterBloc, CenterState>(
                builder: (context, state) {
                  if (state is CenterGotCoursesState) {
                    if (state.courses.isEmpty) {
                      return Center(
                        child: FadeInUp(
                          child: Text(
                            "There are no courses yet.",
                            style: TextStyle(
                              color: AppColors.bronze,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      separatorBuilder:
                          (_, __) => const SizedBox(height: 14),
                      itemCount: state.courses.length,
                      itemBuilder:
                          (context, index) => FadeInUp(
                            duration: Duration(
                              milliseconds: 300 + index * 90,
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  14,
                                ),
                              ),
                              color: Colors.white,
                              elevation: 6,
                              shadowColor: AppColors.taupe
                                  .withOpacity(0.16),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.taupe
                                      .withOpacity(0.14),
                                  radius: 24,
                                  child: const Icon(
                                    Icons.school,
                                    color: AppColors.bronze,
                                    size: 29,
                                  ),
                                ),
                                title: Text(
                                  state.courses[index].title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: AppColors.brown,
                                  ),
                                ),
                                subtitle: Text(
                                  state.courses[index].description,
                                  style: TextStyle(
                                    color: AppColors.mediumGray,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.gold.withOpacity(
                                      0.18,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "${state.courses[index].price}\$",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.bronze,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (
                                            context,
                                          ) => CourseDetailsPage(
                                            course:
                                                state.courses[index],
                                            isStudent: true,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                    );
                  } else if (state is CenterExceptionState) {
                    return FadeIn(
                      duration: const Duration(milliseconds: 350),
                      child: Center(
                        child: Text(
                          state.message.toString(),
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  } else {
                    context.read<CenterBloc>().add(
                      GetCenterCoursesEvent(
                        centerId: widget.centerId,
                      ),
                    );
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePage() {
    return FadeIn(
      duration: const Duration(milliseconds: 520),
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6,
          color: const Color(0xFFF7EEDD),
          shadowColor: AppColors.bronze.withOpacity(0.14),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 36,
              vertical: 35,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.person,
                  size: 60,
                  color: AppColors.softBrown,
                ),
                const SizedBox(height: 15),
                Text(
                  "Profile Page",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: AppColors.brown,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatChannelPage() {
    return FadeIn(
      duration: const Duration(milliseconds: 520),
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6,
          color: const Color(0xFFF7EEDD),
          shadowColor: AppColors.bronze.withOpacity(0.14),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 36,
              vertical: 35,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.chat,
                  size: 55,
                  color: AppColors.softBrown,
                ),
                const SizedBox(height: 15),
                Text(
                  "Chat Channel",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: AppColors.brown,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
