import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/course.dart';
import 'course_appbar.dart';
import 'course_page.dart';

class TeacherCourseView extends StatelessWidget {
  const TeacherCourseView(this.user, this.course, {super.key});

  final UserProfile user;
  final Course course;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return getDeviceType(MediaQuery.of(context)) == DeviceType.mobile
            ? _buildMobileView()
            : _buildTabletView();
      },
    );
  }

  Widget _buildMobileView() {
    return Consumer(
      builder: (context, ref, child) {
        final navIndex = ref.watch(_navIndexProvider);
        final assignmentId = ref.watch(assignmentViewProvider);
        return Scaffold(
          appBar: CourseAppBar(course, assignmentId),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: assignmentId == null
                  ? _navPages[navIndex]['page']
                  // TODO Assignment view here
                  : Container(),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: navIndex,
            onTap: (index) =>
                ref.read(_navIndexProvider.notifier).state = index,
            items: List.generate(
              _navPages.length,
              (index) => BottomNavigationBarItem(
                icon: _navPages[index]['icon'],
                label: _navPages[index]['label'],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabletView() {
    return Container();
  }
}

final _navIndexProvider = StateProvider<int>((ref) => 0);
final _navPages = <Map<String, dynamic>>[
  {
    'page': Container(),
    'icon': const Icon(Icons.circle),
    'label': 'assignments',
  },
  {
    'page': Container(),
    'icon': const Icon(Icons.circle),
    'label': 'submissions',
  },
  {
    'page': Container(),
    'icon': const Icon(Icons.circle),
    'label': 'students',
  },
];
