import 'package:backpack/constants/constants.dart';
import 'package:backpack/features/authentication/authentication.dart';
import 'package:backpack/features/course/view/course_page/course_page.dart';
import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/test_home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
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
            return CoursePage(id: id);
          }),
    ],
  );
});

// class AppRouter {
//   static void goLogin(BuildContext context) {
//     final currentPage = ModalRoute.of(context)?.settings.name;

//     // Simply pop back from register page
//     if (currentPage == Routes.register) {
//       Navigator.pop(context);
//       // Otherwise we are removing all pages in stack and going to login page
//     } else {
//       Navigator.pushNamedAndRemoveUntil(
//           context, Routes.login, (route) => false);
//     }
//   }

//   static void goRegister(BuildContext context) {
//     Navigator.pushNamed(context, Routes.register);
//   }

//   static void goSetup(BuildContext context) {
//     Navigator.pushNamed(context, Routes.setup);
//   }

//   static void goHome(BuildContext context) {
//     final currentPage = ModalRoute.of(context)?.settings.name;

//     // Home page replaces stack from login or setup page
//     if (currentPage == Routes.login || currentPage == Routes.setup) {
//       Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
//     } else {
//       Navigator.popUntil(context, ModalRoute.withName(Routes.home));
//     }
//   }

//   static void goProfile(BuildContext context) {
//     Navigator.pushNamed(context, Routes.profile);
//   }

//   static void goProfileUpdate(BuildContext context) {
//     Navigator.pushNamed(context, Routes.profileUpdate);
//   }

//   static void goCoursePage(BuildContext context, String courseId) {
//     Navigator.pushNamed(
//       context,
//       Routes.course,
//       arguments: CoursePageArguments(courseId: courseId),
//     );
//   }

//   static void goAddAssignment(BuildContext context, String courseId) {
//     Navigator.pushNamed(
//       context,
//       Routes.addAssignment,
//       arguments: AddAssignmentArgments(courseId: courseId),
//     );
//   }

//   static void pop(BuildContext context) {
//     Navigator.pop(context);
//   }
// }
