import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orbitpatter/data/models/message.dart';

class ChatModel {
  final String id;
  final List<String> participants;
  final String message;
  final DateTime createdAt;
  final String lastMessage;
  final DateTime lastMessageTimestamp;
  final List<MessageModel> messages;
  final String receiverName;

  ChatModel({
    required this.id,
    required this.participants,
    required this.message,
    required this.createdAt,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    required this.messages,
    required this.receiverName,
  });

  factory ChatModel.fromMap(Map<String, dynamic> data) {
    return ChatModel(
      id: data['id'] ?? '',
      participants: List<String>.from(data['participants'] ?? []),
      message: data['message'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTimestamp: (data['lastMessageTimestamp'] as Timestamp).toDate(),
      messages: (data['messages'] as List)
          .map((msg) => MessageModel.fromMap(msg))
          .toList(),
      receiverName: data['receiverName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'participants': participants,
      'message': message,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastMessage': lastMessage,
      'lastMessageTimestamp': Timestamp.fromDate(lastMessageTimestamp),
      'messages': messages.map((msg) => msg.toMap()).toList(),
      'receiverName': receiverName,
    };
  }
}
