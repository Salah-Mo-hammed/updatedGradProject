import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad_project_ver_1/core/colors/app_color.dart';
import 'package:grad_project_ver_1/core/common/continue_info.dart';
import 'package:grad_project_ver_1/features/auth/presintation/bloc/auth_bloc.dart';
import 'package:grad_project_ver_1/features/auth/presintation/bloc/auth_event.dart';
import 'package:grad_project_ver_1/features/auth/presintation/bloc/auth_state.dart';
import 'package:grad_project_ver_1/features/auth/presintation/pages/email_verification_page.dart';
import 'package:grad_project_ver_1/features/auth/presintation/pages/forgot_pass_page.dart';
import 'package:grad_project_ver_1/features/auth/presintation/pages/user_type_selection.dart';
import 'package:grad_project_ver_1/features/clean_you_can/center/presentation/pages/center_dashboard_page.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/presentation/pages/student_dashboard.dart';
import 'package:grad_project_ver_1/features/clean_you_can/trainer/presintation/pages/trainer_dashboard.dart';

class AuthWidget extends StatefulWidget {
  final bool doRegister;
  final String? role;
  const AuthWidget({super.key, required this.doRegister, this.role});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final TextEditingController emailController =
      TextEditingController();
  final TextEditingController passwordController =
      TextEditingController();

  int failAttempt = 0;
  bool isLocked = false;
  int countdown = 5;
  // to count faild attempts (3 attempts ) when e attempts reach 3 close button and count 5 seconds and open button again
  void startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown == 1) {
        setState(() {
          isLocked = false;
          failAttempt = 0;
          countdown = 5;
        });
        timer.cancel();
      } else {
        setState(() => countdown--);
      }
    });
  }

  // this method for BlocConsumer listener and its for any changes or actions that have side effect and it dont rebuild ui
  void _handleAuthState(BuildContext context, AuthState state) {
    // authenticated means that user is done logging or signing up
    if (state is Authenticated) {
      final userRole = state.authUser.role;
      // isVerified means that user recieved email verification  and verified the email
      if (state.authUser.isVerified) {
        if (userRole == "Trainer") { //! here change trainer problem *****
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => TrainerDashboardPage(
                    trainerId: state.authUser.uid,
                  ),
            ),
          );

          // isCompletedInfo  means if user completed the info like name , location ,phone number and so on
        } else if (state.authUser.isCompletedInfo!) {
          // ignore: avoid_print
          print(
            "************************************************************************************************************************ role now  is $userRole",
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (_) =>
                      userRole == "center"
                          ? CenterDashboard(
                            centerId: state.authUser.uid,
                          )
                          : StudentDashboard(
                            currentStudentId: state.authUser.uid,
                          ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (_) => ContinueInfo(
                    role: state.authUser.role,
                    userId: state.authUser.uid,
                    email: state.authUser.email,
                  ),
            ),
          );
        }
      } else {
        if (userRole == "Trainer") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => TrainerDashboardPage(
                    trainerId: state.authUser.uid,
                  ),
            ),
          );
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => EmailVerificationPage(role: userRole),
          ),
        );
      }
    }
    // authStatusChecked means that user still didnt register or log in yet (this state shows the authChoicePage to select log in or register)
    // else if (state is AuthStatusChecked && !state.isLoggedIn) {
    //   Future.delayed(const Duration(seconds: 2), () {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (_) => AuthChoicePage()),
    //     );
    //   });
    // }
    else if (state is AuthStateException) {
      // ignore: avoid_print
      print(
        "*********************************************** exception here is :${state.exceptionMessage.toString()}",
      );
      failAttempt++;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.exceptionMessage.toString())),
      );
      if (failAttempt >= 3) {
        setState(() => isLocked = true);
        startCountdown();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: _handleAuthState,
        builder: (context, state) {
          if (state is AuthStateLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return _authWidget(context);
        },
      ),
    );
  }

  Widget _authWidget(BuildContext context) {
    return FadeInDown(
      delay: Duration(milliseconds: 1500),

      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              AppColors.brown,
              AppColors.bronze,
              AppColors.taupe,
              Color(0xFFBD9B69),

              // Colors.orange[900]!,
              // Colors.orange[600]!,
              // Colors.orange[500]!,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 80),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInUp(
                    delay: Duration(milliseconds: 1700),

                    child: _buildText(
                      widget.doRegister ? "Register" : "Login",
                      35,
                      Colors.white,
                      FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  FadeInUp(
                    delay: Duration(milliseconds: 1900),
                    child: Text(
                      "You Can Do It",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(60),
                    topLeft: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 40),
                        FadeInUp(
                          delay: Duration(milliseconds: 2100),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10,
                                  offset: Offset(0, 10),
                                  color: Color.fromRGBO(
                                    225,
                                    95,
                                    27,
                                    .3,
                                  ),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                _buildRowTextFeild(
                                  Icons.email,
                                  "email",
                                  emailController,
                                  false,
                                ),
                                _buildRowTextFeild(
                                  Icons.lock,
                                  "password",
                                  passwordController,
                                  true,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 50),
                        _buildActionButton(context),

                        if (!widget.doRegister)
                          _buildForgetPassword(context),
                        SizedBox(height: 5),
                        if (!widget.doRegister)
                          _buildSwitchAuthMode(context),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            _buildSocialActionButton(
                              "GitHup",
                              3000,
                              Colors.black,
                            ),
                            SizedBox(width: 20),
                            _buildSocialActionButton(
                              "Gmail",
                              3200,
                              Colors.red[600]!,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //! build buttons like facebook and githup
  Expanded _buildSocialActionButton(
    String title,
    int milliseconds,
    Color color,
  ) {
    return
    //! Expanded because its inside row , and to avoid exceptions
    Expanded(
      child: FadeInUp(
        delay: Duration(milliseconds: milliseconds),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: color,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _buildRowTextFeild(
    IconData icon,
    String title,
    TextEditingController controller,
    bool isPassword,
  ) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.bronze),
          SizedBox(width: 5),

          Expanded(
            child: TextFormField(
              obscureText: isPassword,
              controller: controller,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                label: Text(title),
                helperStyle: TextStyle(color: Colors.grey[200]),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //! to build headers like login, you can do it and others
  Text _buildText(
    String title,
    double size,
    Color color,
    FontWeight weight,
  ) {
    return Text(
      title,
      style: TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color,
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return isLocked
        ? Column(
          children: [
            Text(
              "3 attempts failed, wait for $countdown seconds to log in",
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: null,
              child: Text("Retry in $countdown sec"),
            ),
          ],
        )
        : FadeInUp(
          delay: Duration(milliseconds: 2300),
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 50,
            ),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.bronze,
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onPressed: () {
                if (!_validateInputs()) return;
                if (widget.doRegister) {
                  context.read<AuthBloc>().add(
                    AuthRegisterEvent(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                      role: widget.role!,
                    ),
                  );
                } else {
                  context.read<AuthBloc>().add(
                    AuthLogInEvent(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    ),
                  );
                }
              },
              child: _buildText(
                widget.doRegister ? 'Register' : 'Log In',
                17,
                Colors.white,
                FontWeight.bold,
              ),
            ),
          ),
        );
  }

  bool _validateInputs() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email.isEmpty || !email.contains("@")) {
      _showError("Please enter a valid email address.");
      return false;
    }
    if (password.isEmpty || password.length < 6) {
      _showError("Password must be at least 6 characters long.");
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildSwitchAuthMode(BuildContext context) {
    return FadeInUp(
      delay: Duration(milliseconds: 2800),

      child: GestureDetector(
        onTap:
            () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => UserTypeSelectionPage(),
              ),
            ),
        child: FadeInUp(
          child: Text(
            "Don't have an account? Register",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ),
    );
  }

  Widget _buildForgetPassword(BuildContext context) {
    return FadeInUp(
      delay: Duration(milliseconds: 2500),

      child: GestureDetector(
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ForgotPasswordPage()),
            ),
        child: Text(
          "Forgot your password?",
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }
}
