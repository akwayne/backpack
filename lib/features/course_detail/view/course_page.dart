import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/models/models.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'student_view/student_course_view.dart';
import 'teacher_view/teacher_course_view.dart';

class CoursePage extends ConsumerWidget {
  const CoursePage({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(profileProvider);

    return (user.isTeacher)
        ? TeacherCourseView(user, course)
        : StudentCourseView(user, course);
  }
}
