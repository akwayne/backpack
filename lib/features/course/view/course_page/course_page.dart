import 'package:backpack/features/profile/profile.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodel/course_provider.dart';
import 'student_course_view.dart';
import 'teacher_course_view.dart';

final assignmentViewProvider = StateProvider<String?>((ref) => null);

class CoursePage extends ConsumerWidget {
  const CoursePage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(profileProvider);
    final course = ref.read(courseProvider.notifier).getCourseById(id);

    return (user.isTeacher)
        ? TeacherCourseView(user, course)
        : StudentCourseView(user, course);
  }
}
