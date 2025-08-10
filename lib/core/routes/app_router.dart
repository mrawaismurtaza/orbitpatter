import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orbitpatter/features/screens/chat/chat.dart';
import 'package:orbitpatter/features/screens/home/home.dart';
import 'package:orbitpatter/features/screens/login/login.dart';
import 'package:orbitpatter/features/screens/profile/profile.dart';
import 'package:orbitpatter/features/screens/search/search.dart';
import 'package:orbitpatter/features/shared_widgets/navbar.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            body: child,
            bottomNavigationBar: CustomNavBar(
              currentIndex:
                  (state.extra is Map &&
                      (state.extra as Map).containsKey('currentIndex'))
                  ? (state.extra as Map)['currentIndex'] as int
                  : 0,
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
            builder: (context, state) => Home(extra: state.extra),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => Search(extra: state.extra),
          ),
          GoRoute(
            path: '/chat',
            builder: (context, state) => Chat(extra: state.extra),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => Profile(extra: state.extra),
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => Login(extra: state.extra),
      ),
    ],
  );
}
