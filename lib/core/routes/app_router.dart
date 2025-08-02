import 'package:go_router/go_router.dart';
import 'package:orbitpatter/features/screens/home.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // ShellRoute(routes: []),
      GoRoute(
        path: '/',
        builder: (context, state) => const Home(),
      ),
    ],
  );
}