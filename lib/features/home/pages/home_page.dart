import 'package:backpack/components/components.dart';
import 'package:backpack/features/assignment/assignment.dart';
import 'package:backpack/features/calendar/calendar.dart';
import 'package:backpack/features/course/course.dart';
import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/utilities/utilities.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/bottom_nav_bar.dart';
import '../components/home_appbar.dart';
import '../components/nav_drawer.dart';
import '../components/nav_rail.dart';

part 'teacher_nav_pages.dart';
part 'student_nav_pages.dart';

// Stores current home page tab
final homeNavIndexProvider = StateProvider<int>((ref) => 0);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use different navigation pages for students and teachers
    final user = ref.watch(profileProvider);
    final deviceType = getDeviceType(MediaQuery.of(context));
    final orientation = MediaQuery.of(context).orientation;
    final navIndex = ref.watch(homeNavIndexProvider);

    return deviceType == DeviceType.mobile
        ? _buildMobileView(
            orientation: orientation,
            user: user,
            navPages: (user.isTeacher) ? _teacherNavPages : _studentNavPages,
            navIndex: navIndex,
          )
        : _buildTabletView(
            orientation: orientation,
            user: user,
            navPages: (user.isTeacher) ? _teacherNavPages : _studentNavPages,
            navIndex: navIndex,
          );
  }

  Widget _buildMobileView({
    required Orientation orientation,
    required UserProfile user,
    required List<Map<String, dynamic>> navPages,
    required int navIndex,
  }) {
    return Scaffold(
      appBar: HomeAppBar(user: user),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: CustomFadeTransition(
            child: navPages[navIndex]['page'],
          ),
        ),
      ),
      bottomNavigationBar: (orientation == Orientation.portrait)
          ? HomeBottomNavBar(navPages: navPages)
          : null,
      drawer: (orientation == Orientation.landscape)
          ? HomeNavDrawer(navPages: navPages)
          : null,
    );
  }

  Widget _buildTabletView({
    required Orientation orientation,
    required UserProfile user,
    required List<Map<String, dynamic>> navPages,
    required int navIndex,
  }) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          HomeNavRail(navPages: navPages),
          Expanded(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(children: <Widget>[
                  UserNameTile(user: user),
                  const SizedBox(height: 30.0),
                  Expanded(
                    child: CustomFadeTransition(
                      child: navPages[navIndex]['page'],
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
