import 'package:orbitpatter/data/models/chat.dart';
import 'package:orbitpatter/data/models/message.dart';
import 'package:orbitpatter/data/models/user.dart';

abstract class ChatEvent {}

//Users
class FetchUsersEvent extends ChatEvent {
  final List<UserModel> users;

  FetchUsersEvent(this.users);
}



//Chats
class FetchChatsEvent extends ChatEvent {
  final List<ChatModel> chats;

  FetchChatsEvent(this.chats);
}


//Messages
class FetchMessagesEvent extends ChatEvent {
  final List<MessageModel> messages;
  final String chatId;

  FetchMessagesEvent(this.messages, this.chatId);
}
