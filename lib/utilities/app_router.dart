import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../assignment/view/pages/add_assignment.dart';
import '../course/view/pages/course_page.dart';
import '../home/home_nav.dart';
import '../user/view/pages/login_page.dart';
import '../user/view/pages/setup_page.dart';
import '../user/view/pages/profile_page.dart';
import '../user/view/pages/profile_update.dart';
import '../user/view/pages/register_page.dart';

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
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        name: 'register',
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        name: 'setup',
        path: '/setup',
        builder: (context, state) => const SetupPage(),
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
      GoRoute(
        name: 'addAssignment',
        path: '/addAssignment/:courseId',
        builder: (context, state) {
          final courseId = state.params['courseId'] ?? '';
          return AddAssignment(courseId: courseId);
        },
      ),
    ],
  );
}
