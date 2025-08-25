import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orbitpatter/core/utils/logger.dart';
import 'package:orbitpatter/data/models/user.dart';
import 'package:orbitpatter/features/blocs/auth/login_bloc.dart';
import 'package:orbitpatter/features/blocs/auth/login_event.dart';
import 'package:orbitpatter/features/blocs/auth/login_state.dart';
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
    context.read<ChatBloc>().add(FetchChatsEvent([]));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is UserFetchedById) {
          context.push('/chatpage', extra: state.user);
        }
      },
      child: Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text('Chats')),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChatsLoaded) {
              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: state.chats.length,
                itemBuilder: (context, index) {
                  final chat = state.chats[index];
                  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

                  // Filter participants to exclude the current user
                  final otherUser = chat.participants.firstWhere(
                    (participant) => participant.uid != currentUserUid,
                  );

                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      onTap: () {
                        LoggerUtil.info('Receiver Id is ${otherUser.uid}');
                        context.read<LoginBloc>().add(
                          FetchUserByIdEvent(otherUser.uid),
                        );
                        // Navigation now handled by BlocListener
                      },
                      leading: CircleAvatar(
                        backgroundImage: otherUser.photoUrl != null
                            ? CachedNetworkImageProvider(otherUser.photoUrl!)
                            : const Icon(Icons.person)
                                as ImageProvider<Object>,
                      ),
                      title: Text(otherUser.name),
                      subtitle: Text(chat.lastMessage),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8);
                },
              );
            } else {
              return const Center(child: Text('Failed to load chats'));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push('/users');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}