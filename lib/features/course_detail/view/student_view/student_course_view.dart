import 'package:backpack/features/assignment_detail/assignment_detail.dart';
import 'package:backpack/features/assignment_list/assignment_list.dart';
import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/models/models.dart';
import 'package:backpack/utilities/utilities.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodel/course_view_provider.dart';
import '../course_appbar.dart';
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
        final assignmentId = ref.watch(courseViewProvider);
        final assignmentList = ref
            .read(assignListProvider.notifier)
            .getAssignmentsForCourse(course.id);

        return Scaffold(
          appBar: CourseAppBar(course, assignmentId),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: assignmentId == null
                  ? StudentCourseDetail(course, assignmentList)
                  : AssignmentView(id: assignmentId),
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
