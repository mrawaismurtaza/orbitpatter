import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orbitpatter/features/blocs/auth/login_bloc.dart';
import 'package:orbitpatter/features/blocs/auth/login_event.dart';
import 'package:orbitpatter/features/blocs/chat/chat_bloc.dart';
import 'package:orbitpatter/features/blocs/chat/chat_event.dart';
import 'package:orbitpatter/features/blocs/chat/chat_state.dart';
import 'package:redacted/redacted.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(FetchUsersEvent([]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,

        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Theme.of(context).colorScheme.onPrimary,),
          onPressed: () => context.pop(),
        ),
        title: Text('Users', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is UsersLoading) {
            return ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: 6, // Number of shimmer placeholders
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Container(height: 16, width: 10, color: Colors.white),
                    leading: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      width: 30,
                      height: 30,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            ).redacted(context: context, redact: true);
          } else if (state is UsersLoaded) {
            final users = state.users;

            if (users.isEmpty) {
              return const Center(child: Text('No other users found'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user.photoUrl != null
                          ? CachedNetworkImageProvider(user.photoUrl!)
                          : null,
                      child: user.photoUrl == null
                          ? const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 20,
                            )
                          : null,
                    ),
                    title: Text(
                      user.name,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onTap: () {
                      // Handle user tap
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            );
          } else if (state is UsersError) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return const Center(child: Text('No users found'));
          }
        },
      ),
    );
  }
}
