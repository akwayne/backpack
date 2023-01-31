import 'package:backpack/components/components.dart';
import 'package:backpack/features/assignment/assignment.dart';
import 'package:backpack/features/auth/auth.dart';
import 'package:backpack/features/course/course.dart';
import 'package:backpack/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'close_course_button.dart';
import 'course_title_row.dart';
import 'student_course_detail.dart';

// Providers determine which views of the course page we are looking at
final courseNavIndexProvider = StateProvider<int>((ref) => 0);
final assignmentDetailProvider = StateProvider<String?>((ref) => null);

class CoursePage extends ConsumerWidget {
  const CoursePage({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get User info
    final user = ref.watch(userProvider) ?? AppUser.empty();

    // Get Course info
    final course = ref.read(courseProvider.notifier).getCourseFromId(courseId);

    // Determines the visible tab on teacher view
    final navIndex = ref.watch(courseNavIndexProvider);

    // Function to update tab
    void updateTab(index) {
      ref.read(courseNavIndexProvider.notifier).state = index;
      ref.read(assignmentDetailProvider.notifier).state = null;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return getDeviceType(MediaQuery.of(context)) == DeviceType.mobile
            ? _CourseMobileView(
                user: user,
                course: course,
                navIndex: navIndex,
                updateTab: updateTab,
              )
            : _CourseTabletView(
                user: user,
                course: course,
                navIndex: navIndex,
                updateTab: updateTab,
              );
      },
    );
  }
}

class _CourseMobileView extends ConsumerWidget {
  const _CourseMobileView({
    required this.user,
    required this.course,
    required this.navIndex,
    required this.updateTab,
  });

  final AppUser user;
  final Course course;
  final int navIndex;
  final Function updateTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determines if an assignment detail is visible
    String? assignmentView = ref.watch(assignmentDetailProvider);

    // Determine if phone is in portrait or landscape mode
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(course.name),
        // Do not show x icon when assignment is displayed
        actions: assignmentView == null ? [const CloseCourseButton()] : [],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CustomFade(
            child: (assignmentView == null)
                ? (user.isTeacher)
                    ? _teacherNavPages(course)[navIndex]
                    : StudentCourseDetail(course: course)
                : AssignmentDetail(assignmentId: assignmentView),
          ),
        ),
      ),

      // TODO Create drawer for landscape mode

      // Bottom nav bar for portrait mode
      bottomNavigationBar: user.isTeacher && !isLandscape
          ? BottomNavigationBar(
              currentIndex: navIndex,
              onTap: (index) => updateTab(index),
              items: [
                for (var item in _teacherNavIcons)
                  BottomNavigationBarItem(
                    icon: item['icon'],
                    label: item['label'],
                  )
              ],
            )
          : null,
    );
  }
}

class _CourseTabletView extends ConsumerWidget {
  const _CourseTabletView({
    required this.user,
    required this.course,
    required this.navIndex,
    required this.updateTab,
  });

  final AppUser user;
  final Course course;
  final int navIndex;
  final Function updateTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determines if an assignment detail is visible
    String? assignmentView = ref.watch(assignmentDetailProvider);

    return Scaffold(
      body: Row(
        children: [
          if (user.isTeacher)
            CustomNavRail(
              navIndex: navIndex,
              updateTab: updateTab,
              navIcons: _teacherNavIcons,
            ),
          Expanded(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    CourseTitleRow(course: course),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: (user.isTeacher)
                                  ? CustomFade(
                                      child: _teacherNavPages(course)[navIndex])
                                  : StudentCourseDetail(course: course)),
                          const SizedBox(width: 20),
                          // TODO change how data is showed in this section
                          Expanded(
                            child: CustomFade(
                              child: (assignmentView == null)
                                  ? Container()
                                  : AssignmentDetail(
                                      assignmentId: assignmentView),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Icons and labels for nav bar for teacher view
const _teacherNavIcons = <Map<String, dynamic>>[
  {'icon': Icon(Icons.circle), 'label': 'assignments'},
  {'icon': Icon(Icons.circle), 'label': 'submissions'},
  {'icon': Icon(Icons.circle), 'label': 'students'},
];

// Pages for teacher view
List<Widget> _teacherNavPages(Course course) {
  return [
    CourseAssignments(course: course),
    // TODO: submissions take up whole page
    // Filter by new submissions and graded
    const CourseSubmissions(),
    // TODO: Students:
    // Left side is list of students, right is individual student details
    // right contains list of submissions from this student
    CourseStudents(course: course),
  ];
}
