import 'package:backpack/assignment/view/assignment_detail.dart';
import 'package:backpack/course/viewmodel/course_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../utilities/utilities.dart';
import '../model/course.dart';
import 'course_detail.dart';

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
                ? _buildMobileView(course, assignmentView)
                : _buildTabletView(course, assignmentView);
          },
        ),
      ),
    );
  }
}

Widget _buildMobileView(Course course, String? assignmentView) {
  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 300),
    switchInCurve: Curves.easeIn,
    switchOutCurve: Curves.easeIn,
    child: (assignmentView == null)
        ? CourseDetail(course: course)
        : AssignmentDetail(assignmentId: assignmentView),
  );
}

Widget _buildTabletView(Course course, String? assignmentView) {
  return Padding(
    padding: const EdgeInsets.all(32.0),
    child: Row(children: [
      Expanded(child: CourseDetail(course: course)),
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
