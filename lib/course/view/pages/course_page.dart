import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../assignment/view/pages/assignment_detail.dart';
import '../../../user/model/app_user.dart';
import '../../../user/viewmodel/user_provider.dart';
import '../../../utilities/utilities.dart';
import '../../model/course.dart';
import '../../viewmodel/course_provider.dart';
import 'course_students.dart';
import 'student_course_detail.dart';
import 'course_assignments.dart';

// Providers determine which views of the course page we are looking at
final _courseNavIndexProvider = StateProvider<int>((ref) => 0);
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
    final navIndex = ref.watch(_courseNavIndexProvider);

    // Function to update tab
    void updateTab(index) {
      ref.read(_courseNavIndexProvider.notifier).state = index;
    }

    // Pages for teacher view
    final teacherNavPages = <Widget>[
      CourseAssignments(course: course),
      Container(color: Colors.blue),
      CourseStudents(course: course),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        return getDeviceType(MediaQuery.of(context)) == DeviceType.mobile
            ? CourseMobileView(
                user: user,
                course: course,
                navIndex: navIndex,
                updateTab: updateTab,
                navPages: teacherNavPages,
              )
            : CourseMobileView(
                user: user,
                course: course,
                navIndex: navIndex,
                updateTab: updateTab,
                navPages: teacherNavPages,
              );
      },
    );
  }
}

class CourseMobileView extends ConsumerWidget {
  const CourseMobileView({
    super.key,
    required this.user,
    required this.course,
    required this.navIndex,
    required this.updateTab,
    required this.navPages,
  });

  final AppUser user;
  final Course course;
  final int navIndex;
  final Function updateTab;
  final List<Widget> navPages;

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
        actions: assignmentView == null
            ? [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    ref.read(assignmentDetailProvider.notifier).state = null;
                    context.pop();
                  },
                )
              ]
            : [],
      ),

      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeIn,
          child: (assignmentView == null)
              ? (user.isTeacher)
                  ? navPages[navIndex]
                  : StudentCourseDetail(course: course)
              : AssignmentDetail(assignmentId: assignmentView),
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

// TODO Tablet View
Widget _buildTabletView(
  Course course,
  AppUser user,
  String? assignmentView,
) {
  return Padding(
    padding: const EdgeInsets.all(32.0),
    child: Row(children: [
      Expanded(
          child: (user.isTeacher)
              ? CourseAssignments(course: course)
              : StudentCourseDetail(course: course)),
      Expanded(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeIn,
          child: (assignmentView == null)
              ? Container()
              : AssignmentDetail(assignmentId: assignmentView),
        ),
      ),
    ]),
  );
}

// Icons and labels for nav bar for teacher view
const _teacherNavIcons = <Map<String, dynamic>>[
  {'icon': Icon(Icons.circle), 'label': 'assignments'},
  {'icon': Icon(Icons.circle), 'label': 'submissions'},
  {'icon': Icon(Icons.circle), 'label': 'students'},
];
