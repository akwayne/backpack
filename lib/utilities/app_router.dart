import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../course/view/course_page.dart';
import '../home/home_nav.dart';
import '../student/view/profile_page.dart';
import '../student/view/profile_update.dart';
import '../student/view/sign_in_page.dart';

class AppRouter {
  late final router = GoRouter(
    initialLocation: FirebaseAuth.instance.currentUser == null ? '/login' : '/',
    routes: [
      GoRoute(
        name: 'home',
        path: '/',
        builder: (context, state) => const HomeNavigation(),
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => const SigninPage(),
      ),
      GoRoute(
        name: 'profile',
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        name: 'profileUpdate',
        path: '/profileUpdate',
        builder: (context, state) => const ProfileUpdate(),
      ),
      GoRoute(
        name: 'course',
        path: '/course/:courseId',
        pageBuilder: (context, state) {
          final courseId = state.params['courseId'] ?? '';
          return CustomTransitionPage<void>(
            child: CoursePage(courseId: courseId),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    SlideTransition(
              position: animation.drive(Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeIn))),
              child: child,
            ),
          );
        },
      ),
    ],
  );
}
