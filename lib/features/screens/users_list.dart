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
    context.read<LoginBloc>().add(FetchCurrentUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Users'),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is UsersLoading) {
            return ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: 6, // Number of shimmer placeholders
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: Theme.of(context).primaryColor,
                  title: Container(height: 16, color: Colors.white),
                  trailing: Container(
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ).redacted(context: context, redact: true);
          } else if (state is UsersLoaded) {
            final users = state.users
                .where(
                  (u) => u.uid != state.currentUser.uid,
                ) // exclude current user
                .toList();

            if (users.isEmpty) {
              return const Center(child: Text('No other users found'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  tileColor: Theme.of(context).primaryColor,
                  title: Text(
                    user.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      // Handle message icon tap
                    },
                  ),
                  onTap: () {
                    // Handle user tap
                  },
                );
              },
              separatorBuilder: (context, index) => const Divider(),
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
