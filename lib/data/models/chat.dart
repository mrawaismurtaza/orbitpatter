import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orbitpatter/data/models/user.dart';

class ChatModel {
  final String id;
  final List<UserModel> participants;
  final DateTime createdAt;
  final String lastMessage;

  ChatModel({
    required this.id,
    required this.participants,
    required this.createdAt,
    required this.lastMessage,
  });

  factory ChatModel.fromMap(Map<String, dynamic> data, String docId) {
    return ChatModel(
      id: docId,
      participants: List<UserModel>.from(
        data['participants']?.map((user) => UserModel.fromMap(user)) ?? [],
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastMessage: data['lastMessage'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'participants': participants,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastMessage': lastMessage,
    };
  }
}
