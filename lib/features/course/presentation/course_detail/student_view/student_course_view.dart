import 'package:backpack/components/components.dart';
import 'package:backpack/features/assignment/assignment.dart';
import 'package:backpack/features/course/course.dart';

import 'package:backpack/utilities/utilities.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../course_appbar.dart';
import '../course_title_row.dart';
import 'student_course_detail.dart';

class StudentCourseView extends ConsumerWidget {
  const StudentCourseView(this.course, {super.key});

  final Course course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignmentId = ref.watch(courseSubViewProvider);
    final assignments = ref
        .read(assignmentServiceProvider.notifier)
        .getAssignmentsForCourse(course.id);

    return getDeviceType(MediaQuery.of(context)) == DeviceType.mobile
        ? _buildMobileView(assignmentId, assignments)
        : _buildTabletView(assignmentId, assignments);
  }

  Widget _buildMobileView(String? assignmentId, List<Assignment> assignments) {
    return Scaffold(
      appBar: CourseAppBar(course, assignmentId),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomFadeTransition(
            child: assignmentId == null
                ? StudentCourseDetail(course, assignments)
                : AssignmentView(id: assignmentId),
          ),
        ),
      ),
    );
  }

  Widget _buildTabletView(String? assignmentId, List<Assignment> assignments) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              CourseTitleRow(course: course),
              const SizedBox(height: 32.0),
              Expanded(
                child: Row(children: [
                  Expanded(
                    child: StudentCourseDetail(course, assignments),
                  ),
                  const SizedBox(width: 32.0),
                  Expanded(
                    child: assignmentId == null
                        ? Container()
                        : AssignmentView(id: assignmentId),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
