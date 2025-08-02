import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orbitpatter/core/utils/flushbar.dart';
import 'package:orbitpatter/features/blocs/auth/login_bloc.dart';
import 'package:orbitpatter/features/blocs/auth/login_event.dart';
import 'package:orbitpatter/features/blocs/auth/login_state.dart';
import 'package:orbitpatter/features/widgets/button.dart';

class Home extends StatefulWidget {
  final Object? extra;
  const Home({super.key, this.extra});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = widget.extra as Map<String, dynamic>?;
      if (extra?['showLoginSuccess'] == true) {
        OrbitFlushbar.success(
          context,
          'Login successful! ${extra?['userName'] ?? ''}',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
    );
  }
}
