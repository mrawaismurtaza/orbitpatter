import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orbitpatter/data/models/message.dart';
import 'package:orbitpatter/data/models/user.dart';
import 'package:orbitpatter/features/blocs/message/message_bloc.dart';
import 'package:orbitpatter/features/blocs/message/message_event.dart';
import 'package:orbitpatter/features/blocs/message/message_state.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  final UserModel user;
  const ChatPage({super.key, required this.user});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final chatId = getChatId(
      FirebaseAuth.instance.currentUser!.uid,
      widget.user.uid,
    );
    context.read<MessageBloc>().add(FetchMessagesEvent([], chatId));
  }

  String getChatId(String uid1, String uid2) {
    // Always sort to ensure the same chatId for both users
    final ids = [uid1, uid2]..sort();
    return ids.join('_');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            // Profile photo
            CircleAvatar(
              radius: 16,
              backgroundImage: CachedNetworkImageProvider(
                widget.user.photoUrl!,
              ),
            ),
            const SizedBox(width: 16),
            // Name text
            Text(
              widget.user.name,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<MessageBloc, MessagesState>(
              builder: (context, state) {
                if (state is MessagesLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is MessagesLoaded) {
                  return ListView.separated(
                    reverse: true,
                    padding: const EdgeInsets.all(10.0),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      return Align(
                        alignment:
                            message.senderId ==
                                FirebaseAuth.instance.currentUser!.uid
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                message.text,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                // Format the date as you like
                                message.createdAt
                                    .toLocal()
                                    .toString()
                                    .substring(0, 16),
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                  );
                } else if (state is MessagesInitial) {
                  return Center(child: Text('No messages yet'));
                } else {
                  return Center(child: Text('Failed to load chat'));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (_messageController.text.trim().isNotEmpty) {
                      final chatId = getChatId(
                        FirebaseAuth.instance.currentUser!.uid,
                        widget.user.uid,
                      );
                      final participants = [
                        FirebaseAuth.instance.currentUser!.uid,
                        widget.user.uid,
                      ];
            
                      final message = MessageModel(
                        id: const Uuid()
                            .v4(), // Generate a unique ID for the message
                        text: _messageController.text.trim(), // Trim whitespace
                        senderId: FirebaseAuth.instance.currentUser!.uid,
                        createdAt:
                            DateTime.now(), // Use server timestamp when saving to Firestore
                      );
            
                      context.read<MessageBloc>().add(
                        SendMessageWithChatCheckEvent(
                          message,
                          chatId,
                          participants,
                          widget.user.uid,
                          widget.user.name,
                        ),
                      );
            
                      _messageController
                          .clear(); // Clear the text field after sending
                    }
                  },
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
