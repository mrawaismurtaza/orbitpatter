import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orbitpatter/core/services/notification_service.dart';
import 'package:orbitpatter/data/models/message.dart';

class MessageRepository {
  final FirebaseFirestore _firebaseFirestore;
  final NotificationService _notificationService;

  MessageRepository(this._firebaseFirestore, this._notificationService);

  // Define your methods for fetching and sending messages here

  Stream<List<MessageModel>> getMessages(String chatId) {
    return _firebaseFirestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return MessageModel.fromMap(doc.data());
          }).toList();
        });
  }

  Future<void> sendMessage(
    MessageModel message,
    String chatId, {
    required List<String> receiverFcmToken,
  }) async {
    final data = message.toMap();
    data['createdAt'] = FieldValue.serverTimestamp();
    await _firebaseFirestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(data);

    await _firebaseFirestore.collection('chats').doc(chatId).update({
      'lastMessage': message.text,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Send Notification
    _notificationService.sendNotification(
      receiverFcmToken,
      'New Message',
      message.text,
    );
  }
}
