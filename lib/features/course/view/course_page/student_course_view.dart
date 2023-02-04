import 'package:backpack/features/assignment/assignment.dart';
import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/course.dart';
import 'course_appbar.dart';
import 'course_page.dart';
import 'student_course_detail.dart';

class StudentCourseView extends StatelessWidget {
  const StudentCourseView(this.user, this.course, {super.key});

  final UserProfile user;
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
        final assignmentId = ref.watch(assignmentViewProvider);
        final assignmentList = ref
            .read(assignmentProvider.notifier)
            .getAssignmentsForCourse(course.id);

        return Scaffold(
          appBar: CourseAppBar(course, assignmentId),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: assignmentId == null
                  ? StudentCourseDetail(course, assignmentList)
                  // TODO Assignment View goes here
                  : Container(),
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
