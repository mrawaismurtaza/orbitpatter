import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:orbitpatter/features/blocs/chat/chat_bloc.dart';
import 'package:orbitpatter/features/screens/chat/chats.dart';
import 'package:orbitpatter/features/screens/chat/chat_page.dart';
import 'package:orbitpatter/features/screens/home/home.dart';
import 'package:orbitpatter/features/screens/login/login.dart';
import 'package:orbitpatter/features/screens/profile/profile.dart';
import 'package:orbitpatter/features/screens/search/search.dart';
import 'package:orbitpatter/features/screens/users_list.dart';
import 'package:orbitpatter/features/shared_widgets/navbar.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          int currentIndex =
              (state.extra is Map &&
                  (state.extra as Map).containsKey('currentIndex'))
              ? (state.extra as Map)['currentIndex'] as int
              : 0;
          return Scaffold(
            body: IndexedStack(
              index: currentIndex,
              children: const [Home(), Search(), Chats(), Profile()],
            ),
            bottomNavigationBar: CustomNavBar(
              currentIndex: currentIndex,
              onTap: (index) {
                // Handle navigation based on index
                switch (index) {
                  case 0:
                    context.go('/', extra: {'currentIndex': 0});
                    break;
                  case 1:
                    context.go('/search', extra: {'currentIndex': 1});
                    break;
                  case 2:
                    context.go('/chat', extra: {'currentIndex': 2});
                    break;
                  case 3:
                    context.go('/profile', extra: {'currentIndex': 3});
                    break;
                }
              },
            ),
          );
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Home(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => Search(),
          ),
          GoRoute(
            path: '/chat',
            builder: (context, state) => Chats(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => Profile(),
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => Login(),
      ),
      GoRoute(
        path: '/users',
        pageBuilder: (context, state) {
          return _buildPage(context, const UsersList());
        },
      ),

      GoRoute(
        path: '/chats',
        pageBuilder: (context, state) {
          return _buildPage(context, const Chats());
        },
      ),
    ],
  );

  static Page<dynamic> _buildPage(BuildContext context, Widget child) {
    return CustomTransitionPage(
      key: ValueKey(child.runtimeType.toString()),
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
    );
  }
}

class CustomTransitionPage<T> extends Page<T> {
  final Widget child;
  final RouteTransitionsBuilder transitionsBuilder;
  final Duration transitionDuration;

  const CustomTransitionPage({
    required this.child,
    required this.transitionsBuilder,
    this.transitionDuration = const Duration(milliseconds: 300),
    super.key,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      pageBuilder: (context, animation, _) => child,
      transitionsBuilder: transitionsBuilder,
      transitionDuration: transitionDuration,
    );
  }
}
