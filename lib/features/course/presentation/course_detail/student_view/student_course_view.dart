import 'package:backpack/components/components.dart';
import 'package:backpack/features/assignment/assignment.dart';
import 'package:backpack/features/course/course.dart';

import 'package:backpack/utilities/utilities.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../course_appbar.dart';
import 'student_course_detail.dart';

class StudentCourseView extends StatelessWidget {
  const StudentCourseView(this.course, {super.key});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return getDeviceType(MediaQuery.of(context)) == DeviceType.mobile
        ? _buildMobileView()
        : _buildTabletView();
  }

  Widget _buildMobileView() {
    return Consumer(
      builder: (context, ref, child) {
        final assignmentId = ref.watch(coursePageProvider);
        final assignmentList = ref
            .read(assignmentServiceProvider.notifier)
            .getAssignmentsForCourse(course.id);

        return Scaffold(
          appBar: CourseAppBar(course, assignmentId),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomFadeTransition(
                child: assignmentId == null
                    ? StudentCourseDetail(course, assignmentList)
                    : AssignmentView(id: assignmentId),
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
