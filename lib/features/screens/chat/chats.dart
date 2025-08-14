import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orbitpatter/features/blocs/chat/chat_bloc.dart';
import 'package:orbitpatter/features/blocs/chat/chat_event.dart';
import 'package:orbitpatter/features/blocs/chat/chat_state.dart';

class Chats extends StatefulWidget {
  final Object? extra;
  const Chats({super.key, this.extra});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(FetchUsersEvent([])); // Pass an empty list as the required argument
    context.read<ChatBloc>().add(FetchChatsEvent([]));

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Chats'),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatsLoaded) {
            return ListView.builder(
              itemCount: state.chats.length,
              itemBuilder: (context, index) {
                final chat = state.chats[index];
                return ListTile(
                  title: Text(chat.receiverName),
                  subtitle: Text(chat.lastMessage),
                );
              },
            );
          } else {
            return const Center(child: Text('Failed to load chats'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle chat creation or navigation to chat details
          context.push('/users');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}