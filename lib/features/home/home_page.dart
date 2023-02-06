import 'package:backpack/features/assignment_list/assignment_list.dart';
import 'package:backpack/features/course_list/course_list.dart';
import 'package:backpack/features/home/home_nav_provider.dart';
import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/utilities/utilities.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bottom_nav_bar.dart';
import 'home_appbar.dart';
import 'nav_drawer.dart';

part 'teacher_nav_pages.dart';
part 'student_nav_pages.dart';

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
          child: navPages[navIndex]['page'],
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
          // TODO Add NavRail Here
          Expanded(
            child: SafeArea(
              child: Column(children: <Widget>[
                // TODO User Name Row here
                Expanded(
                  child:
                      // TODO Nav Page Here
                      Container(),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
