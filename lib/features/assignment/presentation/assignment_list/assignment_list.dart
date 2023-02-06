import 'package:backpack/features/assignment/assignment.dart';
import 'package:flutter/material.dart';

import 'assignment_card.dart';

class AssignmentList extends StatelessWidget {
  const AssignmentList(this.assignments, {super.key});

  final List<Assignment> assignments;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        assignments.length,
        (index) => AssignmentCard(assignments[index]),
      ),
    );
  }
}
