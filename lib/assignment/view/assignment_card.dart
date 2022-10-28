import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../course/model/course.dart';
import '../../course/model/subject.dart';
import '../../course/viewmodel/course_provider.dart';
import '../model/assignment.dart';

class AssignmentCard extends ConsumerWidget {
  const AssignmentCard({super.key, required this.assignment});

  final Assignment assignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get course information for this assignment
    Course course =
        ref.read(courseProvider.notifier).getCourseFromId(assignment.courseId);

    // TODO Check if assignment is complete or not

// Show assignment card
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        // TODO update leading icon
        leading: const Icon(
          Icons.circle_outlined,
          size: 38,
        ),
        title: Text(assignment.name),
        // Only show course name on homepage
        subtitle: Text(course.name),
        trailing: Image.asset(
          course.subject.getImage,
          color: const Color.fromRGBO(255, 255, 255, 0.3),
          colorBlendMode: BlendMode.modulate,
        ),
        onTap: () {
          // Change view on course page
          // ref.read(courseViewProvider.notifier).state = assignment.id;

          // This checks if we are on the home page or already on course page
          // If we are on the home page, we should navigate to the course page
        },
      ),
    );
  }
}
