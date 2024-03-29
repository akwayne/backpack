import 'package:backpack/constants/constants.dart';
import 'package:backpack/features/assignment/presentation/add_assignment/add_assignment.dart';
import 'package:backpack/features/authentication/authentication.dart';

import 'package:backpack/features/course/course.dart';
import 'package:backpack/features/home/home.dart';
import 'package:backpack/features/profile/profile.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'page_transitions.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final courseListNotifier = ref.read(courseServiceProvider.notifier);
  final repository = ref.watch(userRepositoryProvider);

  return GoRouter(
    initialLocation: repository.currentAuthUser == null ? '/login' : '/',
    routes: [
      GoRoute(
        name: RouteName.home,
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        name: RouteName.login,
        path: '/login',
        builder: (context, state) => const LogInPage(),
      ),
      GoRoute(
        name: RouteName.register,
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        name: RouteName.setup,
        path: '/setup',
        builder: (context, state) => const SetupPage(),
      ),
      GoRoute(
        name: RouteName.profile,
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        name: RouteName.profileUpdate,
        path: '/profileupdate',
        builder: (context, state) => const ProfileUpdate(),
      ),
      GoRoute(
        name: RouteName.course,
        path: '/course/:id',
        pageBuilder: (context, state) {
          final id = state.params['id'] ?? '';
          final course = courseListNotifier.getCourseById(id);
          return PageTransitions.customTransition(
              child: CoursePage(course: course));
        },
      ),
      GoRoute(
        name: RouteName.addAssignment,
        path: '/addAssignment/:id',
        builder: (context, state) {
          final id = state.params['id'] ?? '';
          final course = courseListNotifier.getCourseById(id);
          return AddAssignment(course);
        },
      ),
    ],
  );
});
