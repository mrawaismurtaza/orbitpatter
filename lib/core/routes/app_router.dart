import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:orbitpatter/features/screens/home.dart';
import 'package:orbitpatter/features/screens/login.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: FirebaseAuth.instance.currentUser != null ? '/' : '/login',
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