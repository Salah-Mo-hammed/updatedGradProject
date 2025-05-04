import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class StudentEntity extends Equatable {
  String studentId;
  String name;
  String email;
  String phoneNumber;
  String address;
  String? photoUrl;
  List<String> registerdCourses;

  StudentEntity({
    required this.studentId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
     this.photoUrl,
    this.registerdCourses = const [],
  });

  @override
  List<Object?> get props => [
    studentId,
    name,
    phoneNumber,
    address,
    photoUrl,
    registerdCourses,
  ];
}
