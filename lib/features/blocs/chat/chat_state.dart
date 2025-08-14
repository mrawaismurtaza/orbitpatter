import 'package:orbitpatter/data/models/chat.dart';
import 'package:orbitpatter/data/models/message.dart';
import 'package:orbitpatter/data/models/user.dart';

abstract class ChatState {}


//Users
class UsersInitial extends ChatState {}

class UsersLoading extends ChatState {}

class UsersLoaded extends ChatState {
  final List<UserModel> users;

  final UserModel currentUser;

  UsersLoaded(this.users, this.currentUser);
}

class UsersError extends ChatState {
  final String error;

  UsersError(this.error);
}


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

// Chat
class MessagesInitial extends ChatState {}

class MessagesLoading extends ChatState {}

class MessagesLoaded extends ChatState {
  final List<MessageModel> messages;

  MessagesLoaded(this.messages);
}

class MessagesError extends ChatState {
  final String error;

  MessagesError(this.error);
}

