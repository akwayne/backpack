import 'package:flutter/material.dart';
import 'app_routes.dart';

class AppRouter {
  // Login is at the bottom of the stack
  static void goLogin(BuildContext context) {
    Navigator.popUntil(context, ModalRoute.withName(AppRoutes.login));
  }

  // Register page is pushed on top of login page
  static void goRegister(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.register);
  }

  // Setup page replaces register page on the stack
  static void goSetup(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.setup);
  }

  // Home is pushed on top of login page
  static void goHome(BuildContext context) {
    final currentPage = ModalRoute.of(context)?.settings.name;

    if (currentPage == AppRoutes.login) {
      Navigator.pushNamed(context, AppRoutes.home);
    } else if (currentPage == AppRoutes.setup) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.popUntil(context, ModalRoute.withName(AppRoutes.home));
    }
  }

  static void goProfile(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.profile);
  }

  static void goProfileUpdate(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.profileUpdate);
  }

  static void goCoursePage(BuildContext context, String courseId) {
    Navigator.pushNamed(
      context,
      AppRoutes.course,
      arguments: CoursePageArguments(courseId: courseId),
    );
  }

  static void goAddAssignment(BuildContext context, String courseId) {
    Navigator.pushNamed(
      context,
      AppRoutes.addAssignment,
      arguments: AddAssignmentArgments(courseId: courseId),
    );
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}
