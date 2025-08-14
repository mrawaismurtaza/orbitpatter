import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orbitpatter/data/models/chat.dart';
import 'package:orbitpatter/data/models/message.dart';
import 'package:orbitpatter/data/repositories/auth_repository.dart';
import 'package:orbitpatter/data/repositories/chat_repository.dart';
import 'package:orbitpatter/features/blocs/chat/chat_event.dart';
import 'package:orbitpatter/features/blocs/chat/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  final AuthRepository _authRepository;

  ChatBloc(this._chatRepository, this._authRepository) : super(UsersInitial()) {
    on<FetchUsersEvent>(_fetchUsers);
    on<FetchChatsEvent>(_fetchChats);
    on<FetchMessagesEvent>(_fetchMessages);
  }

  Future<void> _fetchUsers(
    FetchUsersEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(UsersLoading()); // Corrected to emit UsersLoading state
    try {
      final users = await _chatRepository.getUsers();
      final currentUser = await _authRepository.getCurrentUser();
      emit(UsersLoaded(users, currentUser));
    } catch (e) {
      emit(UsersError(e.toString())); // Corrected error state
    }
  }

  Future<void> _fetchChats(
    FetchChatsEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatsInitial());
    try {
      await emit.forEach<List<ChatModel>>(
        _chatRepository.getChats(), // Stream from Firestore
        onData: (chats) => ChatsLoaded(chats), // State on each snapshot
        onError: (error, stackTrace) => ChatsError(error.toString()),
      );
    } catch (e) {
      emit(ChatsError(e.toString()));
    }
  }

  Future<void> _fetchMessages(
    FetchMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(MessagesInitial());
    try {
      await emit.forEach<List<MessageModel>>(
        _chatRepository.getMessages(event.chatId), // Stream from Firestore
        onData: (messages) => MessagesLoaded(messages), // State on each snapshot
        onError: (error, stackTrace) => MessagesError(error.toString()),
      );
    } catch (e) {
      emit(MessagesError(e.toString()));
    }
  }

}
