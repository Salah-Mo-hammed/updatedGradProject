import 'package:grad_project_ver_1/features/clean_you_can/student/domain/entities/studentEntity.dart';

// ignore: must_be_immutable
class StudentModel extends StudentEntity {
  StudentModel({
    required super.studentId,
    required super.name,
    required super.email,
    required super.phoneNumber,
    required super.address,
    required super.photoUrl,
    required super.registerdCourses,
  });

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'photoUrl': photoUrl,
      'registerdCourses': registerdCourses,
    };
  }

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      studentId: json['studentId']as String,
      name: json['name']as String,
      email: json['email']as String,
      phoneNumber: json['phoneNumber']as String,
      address: json['adress']as String,
      photoUrl: json['photoUrl']as String?,
      registerdCourses: List<String>.from(json['registerdCourses'] ?? []), 
    );
  }
}
