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

  ChatBloc(this._chatRepository, this._authRepository) : super(ChatsInitial()) {
    on<FetchChatsEvent>(_fetchChats);
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

 
}
