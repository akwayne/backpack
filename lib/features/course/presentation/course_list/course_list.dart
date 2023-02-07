import 'package:backpack/features/course/course.dart';
import 'package:backpack/utilities/utilities.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'course_card.dart';

class CourseList extends ConsumerWidget {
  const CourseList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(courseServiceProvider);
    final orientation = MediaQuery.of(context).orientation;

    return LayoutBuilder(
      builder: (context, constraints) {
        return getDeviceType(MediaQuery.of(context)) == DeviceType.mobile
            ? _buildMobileView(courses)
            : _buildTabletView(courses, orientation);
      },
    );
  }
}

Widget _buildMobileView(List<Course> courses) {
  return Column(
      children: List.generate(
          courses.length,
          (index) => Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: CourseCard(courses[index]),
              )));
}

Widget _buildTabletView(List<Course> courses, Orientation orientation) {
  return GridView.count(
    primary: false,
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    crossAxisCount: 2,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
    childAspectRatio: orientation == Orientation.portrait ? 2 : 3,
    children: List.generate(
      courses.length,
      (index) => CourseCard(courses[index]),
    ),
  );
}
