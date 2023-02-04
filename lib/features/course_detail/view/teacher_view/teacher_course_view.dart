import 'package:backpack/features/assignment_detail/assignment_detail.dart';
import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/models/models.dart';
import 'package:backpack/utilities/utilities.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodel/course_view_provider.dart';
import '../course_appbar.dart';
import 'teacher_assignments.dart';
import 'teacher_students.dart';
import 'teacher_submissions.dart';

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
        final assignmentId = ref.watch(courseViewProvider);
        return Scaffold(
          appBar: CourseAppBar(course, assignmentId),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: assignmentId == null
                  ? _navPages[navIndex]['page']
                  : AssignmentView(id: assignmentId),
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
    'page': const TeacherCourseAssignments(),
    'icon': const Icon(Icons.circle),
    'label': 'assignments',
  },
  {
    'page': const TeacherCourseSubmissions(),
    'icon': const Icon(Icons.circle),
    'label': 'submissions',
  },
  {
    'page': const TeacherCourseStudents(),
    'icon': const Icon(Icons.circle),
    'label': 'students',
  },
];
