import 'package:orbitpatter/data/models/message.dart';
import 'package:orbitpatter/data/models/user.dart';

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
  final List<String> receiverFcmToken;

  SendMessageEvent(this.message, this.chatId, {required this.receiverFcmToken});
}

class SendMessageWithChatCheckEvent extends MessageEvent {
  final String chatId;
  final List<UserModel> participants;
  final MessageModel message;
  final List<String> receiverFcmToken;

  SendMessageWithChatCheckEvent(
    this.chatId,
    this.participants,
    this.message,
    this.receiverFcmToken,
  );
}