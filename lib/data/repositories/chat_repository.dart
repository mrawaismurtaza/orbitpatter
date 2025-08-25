import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orbitpatter/data/models/chat.dart';
import 'package:orbitpatter/data/models/user.dart';

class ChatRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<List<ChatModel>> getChats() {
    final uid = _firebaseAuth.currentUser?.uid;
    return _firebaseFirestore
        .collection('chats')
        .snapshots()
        .map((snapshot) {
      final chats = snapshot.docs
          .map((doc) => ChatModel.fromMap(
                Map<String, dynamic>.from(doc.data() as Map),
                doc.id,
              ))
          .toList();

      if (uid == null) return <ChatModel>[];

      // Filter client-side: keep chats where any participant.uid == current uid
      return chats.where((chat) {
        return chat.participants.any((p) => p.uid == uid);
      }).toList();
    });
  }

  Future<void> createChatIfNotExists(
    String chatId,
    List<UserModel> participants,
    String lastMessage,
  ) async {
    final chatDoc = _firebaseFirestore.collection('chats').doc(chatId);
    final chatSnapshot = await chatDoc.get();

    if (!chatSnapshot.exists) {
      await chatDoc.set({
        'createdAt': FieldValue.serverTimestamp(),
        'participants': participants.map((user) => user.toMap()).toList(),
        'lastMessage': lastMessage,
      });
    }
  }
}
