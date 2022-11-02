import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../assignment/model/assignment.dart';
import '../../assignment/view/assignment_card.dart';
import '../../assignment/viewmodel/assignment_provider.dart';
import '../model/course.dart';

class CourseDetail extends ConsumerWidget {
  const CourseDetail({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Assignment> courseAssignments = ref
        .read(assignmentProvider.notifier)
        .getCourseAssignments(course.courseId);

    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ListView(
        children: <Widget>[
          Text(
            course.teacher,
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(height: 8),
          Wrap(
            children: [
              Chip(
                label: Text(course.getWeekdayString()),
              ),
              const SizedBox(width: 12),
              Chip(
                label: Text(course.getTimeString()),
              ),
              const SizedBox(width: 12),
              Chip(
                label: Text(course.location),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            primary: false,
            itemCount: courseAssignments.length,
            itemBuilder: ((context, index) =>
                AssignmentCard(assignment: courseAssignments[index])),
          ),
        ],
      ),
    );
  }
}
