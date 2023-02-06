import 'package:backpack/features/assignment/assignment.dart';
import 'package:backpack/features/course/course.dart';
import 'package:backpack/utilities/utilities.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../course_page_provider.dart';
import '../course_appbar.dart';
import 'teacher_assignments.dart';
import 'teacher_students.dart';
import 'teacher_submissions.dart';

class TeacherCourseView extends StatelessWidget {
  const TeacherCourseView(this.course, {super.key});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return getDeviceType(MediaQuery.of(context)) == DeviceType.mobile
        ? _buildMobileView()
        : _buildTabletView();
  }

  Widget _buildMobileView() {
    final navPages = _buildNavPages(course);

    return Consumer(
      builder: (context, ref, child) {
        final navIndex = ref.watch(_navIndexProvider);
        final assignmentId = ref.watch(coursePageProvider);
        return Scaffold(
          appBar: CourseAppBar(course, assignmentId),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: assignmentId == null
                  ? navPages[navIndex]['page']
                  : AssignmentView(id: assignmentId),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: navIndex,
            onTap: (index) =>
                ref.read(_navIndexProvider.notifier).state = index,
            items: List.generate(
              navPages.length,
              (index) => BottomNavigationBarItem(
                icon: navPages[index]['icon'],
                label: navPages[index]['label'],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabletView() {
    return Text(course.name);
  }

  List<Map<String, dynamic>> _buildNavPages(Course course) {
    return [
      {
        'page': TeacherCourseAssignments(course),
        'icon': const Icon(Icons.circle),
        'label': 'assignments',
      },
      {
        'page': TeacherCourseSubmissions(course),
        'icon': const Icon(Icons.circle),
        'label': 'submissions',
      },
      {
        'page': TeacherCourseStudents(course),
        'icon': const Icon(Icons.circle),
        'label': 'students',
      },
    ];
  }
}

final _navIndexProvider = StateProvider<int>((ref) => 0);
