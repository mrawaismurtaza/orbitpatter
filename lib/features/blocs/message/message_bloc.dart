import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orbitpatter/data/models/message.dart';
import 'package:orbitpatter/data/repositories/chat_repository.dart';
import 'package:orbitpatter/data/repositories/message_repository.dart';
import 'package:orbitpatter/features/blocs/message/message_event.dart';
import 'package:orbitpatter/features/blocs/message/message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessagesState> {
  final MessageRepository _messageRepository;
  final ChatRepository _chatRepository;

  MessageBloc(this._messageRepository, this._chatRepository) : super(MessagesInitial()) {
    on<FetchMessagesEvent>(_fetchMessages);

    on<SendMessageEvent>(_sendMessage);

    on<SendMessageWithChatCheckEvent>(_sendMessageWithChatCheck);
  }

   Future<void> _fetchMessages(
    FetchMessagesEvent event,
    Emitter<MessagesState> emit,
  ) async {
    emit(MessagesInitial());
    try {
      await emit.forEach<List<MessageModel>>(
        _messageRepository.getMessages(event.chatId), // Stream from Firestore
        onData: (messages) => MessagesLoaded(messages), // State on each snapshot
        onError: (error, stackTrace) => MessagesError(error.toString()),
      );
    } catch (e) {
      emit(MessagesError(e.toString()));
    }
  }

  Future<void> _sendMessage(
    SendMessageEvent event,
    Emitter<MessagesState> emit,
  ) async {
    emit(MessageSending());
    try {
      await _messageRepository.sendMessage(event.message, event.chatId);
      emit(MessageSent(event.message));
    } catch (e) {
      emit(MessagesError(e.toString()));
    }
  }

  Future<void> _sendMessageWithChatCheck(
    SendMessageWithChatCheckEvent event,
    Emitter<MessagesState> emit,
  ) async {
    emit(MessageSending());
    try {
      await _chatRepository.createChatIfNotExists(
        event.chatId,
        event.participants,
        event.receiverId,
        event.receiverName,
      );
      await _messageRepository.sendMessage(event.message, event.chatId);
      emit(MessageSent(event.message));
    } catch (e) {
      emit(MessagesError(e.toString()));
    }
  }
}
