import 'package:backpack/features/assignment/assignment.dart';
import 'package:backpack/features/authentication/pages/test_home_page.dart';

import 'package:backpack/features/course/course.dart';
import 'package:backpack/features/authentication/authentication.dart';
import 'package:backpack/features/profile/profile.dart';

import 'package:flutter/material.dart';

part 'route_arguments.dart';

class AppRoutes {
  static const home = '/';
  static const login = '/login';
  static const register = '/register';
  static const setup = '/setup';
  static const profile = '/profile';
  static const profileUpdate = '/profileupdate';
  static const course = '/course';
  static const addAssignment = '/addassignment';

  static Map<String, Widget Function(BuildContext)> routes = {
    home: (context) => const TestHomePage(),
    login: (context) => const LogInPage(),
    register: (context) => const RegisterPage(),
    setup: (context) => const SetupPage(),
    profile: (context) => const ProfilePage(),
    profileUpdate: (context) => const ProfileUpdate(),
    course: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as CoursePageArguments;
      return CoursePage(
        courseId: args.courseId,
      );
    },
    addAssignment: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as AddAssignmentArgments;
      return AddAssignment(
        courseId: args.courseId,
      );
    },
  };
}
