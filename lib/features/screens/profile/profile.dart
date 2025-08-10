import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orbitpatter/features/blocs/auth/login_bloc.dart';
import 'package:orbitpatter/features/blocs/auth/login_event.dart';
import 'package:orbitpatter/features/blocs/auth/login_state.dart';
import 'package:orbitpatter/features/shared_widgets/button.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: BlocConsumer<LoginBloc, LoginState>(
            builder: (context, state) {
              return CustomButton(
                text: 'Logout',
                onPressed: () {
                  context.read<LoginBloc>().add(ResetLoginEvent());
                },
              );
            },
            listener: (context, state) async {
              if (state is LoginReset) {
                  context.go('/login', extra: {'showLogoutSuccess': true});
              }
            },
          ),
        ),
      ),
    );
  }
}
