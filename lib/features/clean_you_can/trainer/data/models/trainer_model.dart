import 'package:grad_project_ver_1/features/clean_you_can/trainer/domain/entities/trainer_entity.dart';

class TrainerModel extends TrainerEntity {
  TrainerModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.password,
    required super.phone,
    required super.imageUrl,
    required super.coursesIds,
    required super.centerId,
  });

  Map<String, dynamic> toJson(String addgeneretedId) {
    return {
      'uid': addgeneretedId,
      'centerId': centerId,
      'name': name,
      'email': email,
      'phone': phone,
      'imageUrl': imageUrl,
      'coursesIds': coursesIds,
    };
  }

  factory TrainerModel.fromJson(Map<String, dynamic> json) {
    return TrainerModel(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String,
      imageUrl: json['imageUrl'] as String?,
      coursesIds: List<String>.from(json['coursesIds'] ?? []),
      centerId: json['centerId']as String,
    );
  }
}
