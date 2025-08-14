import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id;
  final List<String> participants;
  final DateTime createdAt;
  final String lastMessage;
  final String receiverName;
  final String receiverId;

  ChatModel({
    required this.id,
    required this.participants,
    required this.createdAt,
    required this.lastMessage,
    required this.receiverName,
    required this.receiverId,
  });

  factory ChatModel.fromMap(Map<String, dynamic> data, String docId) {
    return ChatModel(
      id: docId,
      participants: List<String>.from(data['participants'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastMessage: data['lastMessage'] ?? '',
      receiverName: data['receiverName'] ?? '',
      receiverId: data['receiverId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'participants': participants,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastMessage': lastMessage,
      'receiverName': receiverName,
      'receiverId': receiverId,
    };
  }
}
