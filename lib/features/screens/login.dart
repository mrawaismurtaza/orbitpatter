import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orbitpatter/core/utils/flushbar.dart';
import 'package:orbitpatter/features/blocs/auth/login_bloc.dart';
import 'package:orbitpatter/features/blocs/auth/login_event.dart';
import 'package:orbitpatter/features/blocs/auth/login_state.dart';
import 'package:orbitpatter/features/widgets/button.dart';

class Login extends StatefulWidget {
  final Object? extra;
  const Login({super.key, this.extra});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = widget.extra as Map<String, dynamic>?;
      if (extra?['showLogoutSuccess'] == true) {
        OrbitFlushbar.success(
          context,
          'Logout successful!',
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text('Login Screen'))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Welcome to the Login Screen'),
            BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) async {
                if (state is GoogleLoginSuccess) {
                  context.go(
                    '/',
                    extra: {
                      'showLoginSuccess': true,
                      'userName': state.user.name,
                    },
                  );
                } else if (state is GoogleLoginFailure) {
                  OrbitFlushbar.error(context, state.error);
                  debugPrint('Login failed: ${state.error}');
                }
              },
              builder: (context, state) {
                return CustomButton(
                  text: 'Login',
                  onPressed: () {
                    // Trigger the login event
                    context.read<LoginBloc>().add(LoginWithGoogleEvent());
                  },
                  color: Theme.of(context).colorScheme.primary,
                  leadingImage: 'assets/images/google_icon.png',
                  width: 200,
                  height: 50,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
