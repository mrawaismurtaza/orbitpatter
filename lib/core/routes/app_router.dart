import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:orbitpatter/features/screens/home/home.dart';
import 'package:orbitpatter/features/screens/login/login.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // ShellRoute(routes: []),
      GoRoute(
        path: '/',
        builder: (context, state) => Home(extra: state.extra),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => Login(extra: state.extra),
      ),
    ],
  );
}