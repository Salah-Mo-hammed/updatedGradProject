import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/presentation/bloc/student_bloc/student_bloc.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/presentation/bloc/student_bloc/student_event.dart';
import 'package:grad_project_ver_1/features/clean_you_can/student/presentation/bloc/student_bloc/student_state.dart';

class PaymentMethodPage extends StatefulWidget {
  final String currentStudentUid;
  final String currentCourseUid;
  const PaymentMethodPage({
    super.key,
    required this.currentCourseUid,
    required this.currentStudentUid,
  });

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  @override
  void initState() {
    context.read<StudentBloc>().add(
      EnrollInCourseEvent(
        studentUid: widget.currentStudentUid,
        courseUid: widget.currentCourseUid,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<StudentBloc, StudentState>(
        builder: (context, state) {
          if (state is StudentLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is StudentExceptionState) {
            return Center(child: Text(state.message.toString()));
          } else {
            return Center(
              child: Text(" ok i think payment is good now "),
            );
          }
        },
      ),
    );
  }
}
