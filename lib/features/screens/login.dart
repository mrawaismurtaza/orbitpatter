import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orbitpatter/core/theme/app_theme.dart';
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
        OrbitFlushbar.success(context, 'Logout successful!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Top curved image with fade
          Stack(
            children: [
              ClipPath(
                clipper: BottomCurveClipper(),
                child: Image.asset(
                  'assets/images/login_img.jpeg',
                  width: double.infinity,
                  height: height * 0.7,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: height * 0.7,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.transparent,
                          AppTheme.light.colorScheme.primary.withOpacity(0.7),
                          AppTheme.light.colorScheme.primary.withOpacity(0.9),
                        ],
                        stops: [0.0, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),
              ),


              Positioned(
                top: 70,
                left: 20,
                child: Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Positioned(
                top: 120,
                left: 20,
                child: Text(
                  'Login to continue',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18,
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 200, left: 20, right: 20),
                child: Text(
                  'Explore, Connect & Discover Together',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 40,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 4,
                  // softWrap: true,
                  overflow: TextOverflow.ellipsis, // optional
                  textAlign: TextAlign.left, // for center alignment
                ),
              ),
            ],
          ),

          const Spacer(),

          // Login button using Bloc
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
              if (state is GoogleLoginLoading) {
                return const SizedBox(
                  height: 80,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomButton(
                  text: 'Continue with Google',
                  onPressed: () {
                    context.read<LoginBloc>().add(LoginWithGoogleEvent());
                  },
                  color: Theme.of(context).colorScheme.primary,
                  leadingImage: 'assets/images/google_icon.png',
                  width: 200,
                  height: 50,
                ),
              );
            },
          ),

          const Spacer(),

          Container(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'By continuing, you agree to our Terms of Service and Privacy Policy.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// 🔹 Custom clipper for bottom curve
class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height - 50); // Start from bottom left up
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0); // Top right
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
