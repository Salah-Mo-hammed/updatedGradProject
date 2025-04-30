import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_project_ver_1/features/clean_you_can/course/domain/entities/Course-entity.dart';

class CourseModel extends CourseEntity {
  
  CourseModel({
    required super.courseId,
    required super.title,
    required super.description,
    required super.centerId,
    required super.price,
    super.enrolledStudents = const {},
    required super.startDate,
    required super.endDate,
    required super.topics,
    super.imageUrl,
    required super.maxStudents,
  });

  /// **🔹 تحويل من JSON إلى CourseModel**
  factory CourseModel.fromJson(Map<String, dynamic> json) {
  return CourseModel(
    courseId: json['courseId'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    centerId: json['centerId'] as String,
    price: (json['price'] as num).toDouble(),
    enrolledStudents: (json['enrolledStudents'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toSet() ??
        {},
    startDate: json['startDate'] is Timestamp
        ? (json['startDate'] as Timestamp).toDate()
        : DateTime.parse(json['startDate']), // يحل المشكلة
    endDate: json['endDate'] is Timestamp
        ? (json['endDate'] as Timestamp).toDate()
        : DateTime.parse(json['endDate']),
    topics: List<String>.from(json['topics'] ?? []),
    imageUrl: json['imageUrl'] as String?,
    maxStudents: json['maxStudents'] as int,
  );
}

  /// **🔹 تحويل من CourseModel إلى JSON (Firestore Map)**
  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'title': title,
      'description': description,
      'centerId': centerId,
      'price': price,
      'enrolledStudents': enrolledStudents, // يتم حفظها كما هي
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'topics': topics,
      'imageUrl': imageUrl,
      'maxStudents': maxStudents,
    };
  }

  // /// **🔹 إنشاء نسخة جديدة مع تغيير بيانات معينة فقط**
  CourseModel copyWith({
    String? courseId,
    String? title,
    String? description,
    String? centerId,
    double? price,
    Set<String>? enrolledStudents,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? topics,
    String? imageUrl,
    int? maxStudents,
  }) {
    return CourseModel(
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      centerId: centerId ?? this.centerId,
      price: price ?? this.price,
      enrolledStudents: enrolledStudents ?? this.enrolledStudents,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      topics: topics ?? this.topics,
      imageUrl: imageUrl ?? this.imageUrl,
      maxStudents: maxStudents ?? this.maxStudents,
    );
  }
}
