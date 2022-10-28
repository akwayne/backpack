import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/course_provider.dart';
import 'course_card.dart';

class CourseList extends ConsumerWidget {
  const CourseList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseList = ref.watch(courseProvider);
    return ListView.builder(
      itemCount: courseList.length,
      itemBuilder: (context, index) {
        final course = courseList[index];
        return CourseCard(course: course);
      },
    );
  }
}
