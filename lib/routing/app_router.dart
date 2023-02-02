import 'package:flutter/material.dart';
import 'app_routes.dart';

class AppRouter {
  static void goLogin(BuildContext context) {
    final currentPage = ModalRoute.of(context)?.settings.name;

    // Simply pop back from register page
    if (currentPage == AppRoutes.register) {
      Navigator.pop(context);
      // Otherwise we are removing all pages in stack and going to login page
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.login, (route) => false);
    }
  }

  static void goRegister(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.register);
  }

  static void goSetup(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.setup);
  }

  static void goHome(BuildContext context) {
    final currentPage = ModalRoute.of(context)?.settings.name;

    // Home page replaces stack from login or setup page
    if (currentPage == AppRoutes.login || currentPage == AppRoutes.setup) {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.home, (route) => false);
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
