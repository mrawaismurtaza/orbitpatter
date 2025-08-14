import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orbitpatter/data/models/chat.dart';

class ChatRepository {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;


  Stream<List<ChatModel>> getChats() {
  final uid = _firebaseAuth.currentUser?.uid;
  return _firebaseFirestore
    .collection('chats')
    .where('participants', arrayContains: uid)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => ChatModel.fromMap(doc.data(), doc.id)).toList());
}


  Future<void> createChatIfNotExists(String chatId, List<String> participants, String receiverName, String receiverId) async {
  final chatDoc = _firebaseFirestore.collection('chats').doc(chatId);
  final chatSnapshot = await chatDoc.get();

  if (!chatSnapshot.exists) {
    await chatDoc.set({
      'participants': participants,
      'lastMessage': '',
      'receiverName': receiverName,
      'createdAt': FieldValue.serverTimestamp(),
      'receiverId': receiverId,
      // 'receiverId': participants.firstWhere((id) => id != _firebaseAuth.currentUser?.uid),
    });
  }
}


 
}