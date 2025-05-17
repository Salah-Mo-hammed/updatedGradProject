import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_project_ver_1/features/chat/data/model/chat_room_model.dart';
import 'package:grad_project_ver_1/features/chat/data/model/message_model.dart';
import 'package:grad_project_ver_1/features/chat/domain/entities/chat_room_entity.dart';
import 'package:grad_project_ver_1/features/chat/domain/entities/message_entity.dart';

class ChatRemoteDataSource {
  final _firestore = FirebaseFirestore.instance;

  Future<ChatRoomEntity> getOrCreateChatRoom({
    required String studentId,
    required String trainerId,
    // required String courseId,
  }) async {
    final query =
        await _firestore
            .collection('chat_rooms')
            .where('studentId', isEqualTo: studentId)
            .where('trainerId', isEqualTo: trainerId)
            // .where('courseId', isEqualTo: courseId)
            .limit(1)
            .get();

    if (query.docs.isNotEmpty) {
      return ChatRoomModel.fromMap(
        query.docs.first.data(),
        query.docs.first.id,
      );
    }

    final newRoom = ChatRoomModel(
      id: '',
      studentId: studentId,
      trainerId: trainerId,
      // courseId: courseId,
      createdAt: DateTime.now(),
    );

    final doc = await _firestore
        .collection('chat_rooms')
        .add(newRoom.toMap());
    return newRoom.copyWith(id: doc.id);
  }

  Future<void> sendMessage({
    required String roomId,
    required MessageModel message,
  }) async {
    await _firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .add(message.toMap());
  }

  Stream<List<MessageEntity>> streamMessages(String roomId) {
    return _firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => MessageModel.fromMap(doc.data(), doc.id),
                  )
                  .toList(),
        );
  }
}
