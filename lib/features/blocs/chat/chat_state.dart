import 'package:orbitpatter/data/models/chat.dart';
import 'package:orbitpatter/data/models/message.dart';
import 'package:orbitpatter/data/models/user.dart';

abstract class ChatState {}




//Chats
class ChatsInitial extends ChatState {}

class ChatsLoading extends ChatState {}

class ChatsLoaded extends ChatState {
  final List<ChatModel> chats;

  ChatsLoaded(this.chats);
}

class ChatsError extends ChatState {
  final String error;

  ChatsError(this.error);
}




