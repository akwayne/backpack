import 'package:backpack/features/auth/auth.dart';
import 'package:backpack/home/home_nav.dart';

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
    home: (context) => const HomeNavigation(),
    login: (context) => const LoginPage(),
  };
}
