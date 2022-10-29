import 'package:backpack/student/viewmodel/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../course/model/course.dart';
import '../../course/model/subject.dart';
import '../../course/view/course_page.dart';
import '../../course/viewmodel/course_provider.dart';
import '../../student/model/student.dart';
import '../model/assignment.dart';
import 'animated_check.dart';

class AssignmentCard extends ConsumerWidget {
  const AssignmentCard({super.key, required this.assignment});

  final Assignment assignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get course information for this assignment
    Course course =
        ref.read(courseProvider.notifier).getCourseFromId(assignment.courseId);

    // Student info to display
    final Student student = ref.watch(studentProvider) ?? Student.empty();

    // checks whether a particular assignment is complete for this student
    final Widget checkbox = student.completed.contains(assignment.id)
        ? const AnimatedCheck()
        : const Icon(
            Icons.circle_outlined,
            size: 38,
          );

// Show assignment card
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: checkbox,
        title: Text(assignment.name),
        // Only show subtitle on home page
        subtitle: ModalRoute.of(context)?.settings.name == '/'
            ? Text(course.name)
            : null,
        trailing: Image.asset(
          course.subject.getImage,
          color: const Color.fromRGBO(255, 255, 255, 0.3),
          colorBlendMode: BlendMode.modulate,
        ),
        onTap: () {
          // Change view on course page
          ref.read(courseViewProvider.notifier).state = assignment.id;

          // This checks if we are on the home page or already on course page
          // If we are on the home page, we should navigate to the course page
          if (ModalRoute.of(context)?.settings.name == '/') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => CoursePage(course: course)),
              ),
            );
          }
        },
      ),
    );
  }
}
