import 'package:orbitpatter/data/models/message.dart';

abstract class MessagesState {}

class MessagesInitial extends MessagesState {}

class MessagesLoading extends MessagesState {}

class MessagesLoaded extends MessagesState {
  final List<MessageModel> messages;

  MessagesLoaded(this.messages);
}

class MessagesError extends MessagesState {
  final String error;

  MessagesError(this.error);
}


//Message Sent
class MessageSending extends MessagesState {}

class MessageSent extends MessagesState {
  final MessageModel message;

  MessageSent(this.message);
}