import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orbitpatter/data/models/chat.dart';
import 'package:orbitpatter/data/models/message.dart';
import 'package:orbitpatter/data/models/user.dart';

class ChatRepository {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<UserModel>> getUsers() async {
    final snapshot = await _firebaseFirestore.collection('users').where('uid', isNotEqualTo: _firebaseAuth.currentUser?.uid).get();
    final users = snapshot.docs.map((doc) {
      return UserModel.fromMap(doc.data());
    }).toList();
    return users;
  }

  Stream<List<ChatModel>> getChats() {
    return _firebaseFirestore.collection('chats').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ChatModel.fromMap(doc.data());
      }).toList();
    });
  }


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


}