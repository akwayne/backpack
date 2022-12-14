import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../assignment/view/student_assignment_detail.dart';
import '../../assignment/view/teacher_assignment_detail.dart';
import '../../user/model/app_user.dart';
import '../../user/viewmodel/user_provider.dart';
import '../../utilities/utilities.dart';
import '../model/course.dart';
import '../viewmodel/course_provider.dart';
import 'student_course_detail.dart';
import 'teacher_course_detail.dart';

// Provider determines which view of the course page we are looking at
final courseViewProvider = StateProvider<String?>((ref) => null);

class CoursePage extends ConsumerWidget {
  const CoursePage({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determines if an assignment detail is visible
    String? assignmentView = ref.watch(courseViewProvider);

    // Get course info to display
    Course course = ref.read(courseProvider.notifier).getCourseFromId(courseId);

    DeviceType device = getDeviceType(MediaQuery.of(context));

    // User info to display
    final user = ref.watch(userProvider) ?? AppUser.empty();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          course.name,
        ),
        // do not show x icon on mobile when assignment is showing
        actions: device == DeviceType.mobile && assignmentView != null
            ? []
            : [
                IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      ref.read(courseViewProvider.notifier).state = null;
                      context.pop();
                    })
              ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return device == DeviceType.mobile
                ? _buildMobileView(course, user, assignmentView)
                : _buildTabletView(course, user, assignmentView);
          },
        ),
      ),
    );
  }
}

Widget _buildMobileView(Course course, AppUser user, String? assignmentView) {
  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 300),
    switchInCurve: Curves.easeIn,
    switchOutCurve: Curves.easeIn,
    child: (user.isTeacher)
        ? (assignmentView == null)
            ? TeacherCourseDetail(course: course)
            : TeacherAssignmentDetail(assignmentId: assignmentView)
        : (assignmentView == null)
            ? StudentCourseDetail(course: course)
            : StudentAssignmentDetail(assignmentId: assignmentView),
  );
}

Widget _buildTabletView(Course course, AppUser user, String? assignmentView) {
  return Padding(
    padding: const EdgeInsets.all(32.0),
    child: Row(children: [
      Expanded(
          child: (user.isTeacher)
              ? TeacherCourseDetail(course: course)
              : StudentCourseDetail(course: course)),
      Expanded(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeIn,
          child: (assignmentView == null)
              ? Container()
              : (user.isTeacher)
                  ? TeacherAssignmentDetail(assignmentId: assignmentView)
                  : StudentAssignmentDetail(assignmentId: assignmentView),
        ),
      ),
    ]),
  );
}
