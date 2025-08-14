import 'package:orbitpatter/data/models/chat.dart';
import 'package:orbitpatter/data/models/message.dart';
import 'package:orbitpatter/data/models/user.dart';

abstract class ChatEvent {}



//Chats
class FetchChatsEvent extends ChatEvent {
  final List<ChatModel> chats;

  FetchChatsEvent(this.chats);
}



