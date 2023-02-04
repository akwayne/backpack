import 'package:backpack/constants/constants.dart';
import 'package:backpack/features/authentication/authentication.dart';
import 'package:backpack/features/course_detail/course_detail.dart';
import 'package:backpack/features/course_list/course_list.dart';
import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/test_home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final courseListNotifier = ref.read(courseListProvider.notifier);

  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        name: RouteName.home,
        path: '/',
        builder: (context, state) => const TestHomePage(),
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
          builder: (context, state) {
            final id = state.params['id'] ?? '';
            final course = courseListNotifier.getCourseById(id);
            return CoursePage(course: course);
          }),
    ],
  );
});
