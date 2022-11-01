import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/utilities.dart';
import '../model/course.dart';
import '../viewmodel/course_provider.dart';
import 'course_card.dart';

class CourseList extends ConsumerWidget {
  const CourseList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseList = ref.watch(courseProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        return getDeviceType(MediaQuery.of(context)) == DeviceType.mobile
            ? _buildMobileView(courseList)
            : _buildTabletView(context, courseList);
      },
    );
  }
}

Widget _buildMobileView(List<Course> courses) {
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: ListView.separated(
      itemCount: courses.length,
      itemBuilder: (context, index) => CourseCard(course: courses[index]),
      separatorBuilder: (context, index) => const SizedBox(height: 10),
    ),
  );
}

Widget _buildTabletView(BuildContext context, List<Course> courses) {
  return Padding(
    padding: const EdgeInsets.only(top: 16.0),
    child: ListView(
      primary: true,
      scrollDirection: Axis.vertical,
      children: [
        Text(
          'My Classes',
          style: Theme.of(context).textTheme.headline5,
        ),
        const SizedBox(height: 22.0),
        GridView.count(
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? 2.5
                  : 3,
          children: List.generate(
            courses.length,
            (index) => CourseCard(course: courses[index]),
          ),
        ),
      ],
    ),
  );
}
