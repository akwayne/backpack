import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/assignment_provider.dart';
import 'assignment_card.dart';

class AssignmentList extends ConsumerWidget {
  const AssignmentList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignmentList = ref.watch(assignmentProvider);
    return ListView.builder(
      itemCount: assignmentList.length,
      itemBuilder: (context, index) {
        final assignment = assignmentList[index];
        return AssignmentCard(assignment: assignment);
      },
    );
  }
}
