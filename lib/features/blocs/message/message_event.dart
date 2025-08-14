import 'package:orbitpatter/data/models/message.dart';

abstract class MessageEvent {}

//Messages
class FetchMessagesEvent extends MessageEvent {
  final List<MessageModel> messages;
  final String chatId;

  FetchMessagesEvent(this.messages, this.chatId);
}

class SendMessageEvent extends MessageEvent {
  final MessageModel message;
  final String chatId;

  SendMessageEvent(this.message, this.chatId);
}

class SendMessageWithChatCheckEvent extends MessageEvent {
  final MessageModel message;
  final String chatId;
  final List<String> participants;
  final String receiverId;
  final String receiverName;

  SendMessageWithChatCheckEvent(
    this.message,
    this.chatId,
    this.participants,
    this.receiverId,
    this.receiverName,
  );
}