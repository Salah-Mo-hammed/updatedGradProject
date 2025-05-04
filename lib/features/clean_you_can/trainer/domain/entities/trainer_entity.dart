class TrainerEntity {
  final String uid;
  final String centerId;
  final String name;
  final String email;

  final String phone;
  final String? imageUrl;
  final List<String>? coursesIds;
  TrainerEntity({required this.email,required this.centerId,
    required this.uid,
    required this.name,
    required this.phone,
    required this.imageUrl,
    required this.coursesIds,
  });
}
