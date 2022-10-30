import 'package:backpack/student/viewmodel/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/utilities.dart';
import '../model/assignment.dart';
import '../viewmodel/assignment_provider.dart';
import 'assignment_card.dart';

class AssignmentList extends ConsumerWidget {
  const AssignmentList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get assignments to display
    final assignmentList = ref.watch(assignmentProvider);

    // Find completed assignments and sort into 2 lists
    final doneIds = ref.watch(studentProvider)!.completed;
    final doneList = assignmentList
        .where((assignment) => doneIds.contains(assignment.id))
        .toList();
    final todoList = assignmentList
        .where((assignment) => !doneIds.contains(assignment.id))
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        return getDeviceType(MediaQuery.of(context)) == DeviceType.mobile
            ? _buildMobileView(context, todoList, doneList)
            : _buildTabletView(context, todoList, doneList);
      },
    );
  }
}

Widget _buildMobileView(
  BuildContext context,
  List<Assignment> todoList,
  List<Assignment> doneList,
) {
  return ListView(
    primary: true,
    children: [
      const SizedBox(height: 24),
      Text(
        'Today\'s Work',
        style: Theme.of(context).textTheme.headline5,
      ),
      const SizedBox(height: 16),
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        primary: false,
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          final assignment = todoList[index];
          return AssignmentCard(assignment: assignment);
        },
      ),
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        primary: false,
        itemCount: doneList.length,
        itemBuilder: (context, index) {
          final assignment = doneList[index];
          return AssignmentCard(assignment: assignment);
        },
      ),
    ],
  );
}

Widget _buildTabletView(
  BuildContext context,
  List<Assignment> todoList,
  List<Assignment> doneList,
) {
  return Row(
    children: <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Work',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (context, index) {
                  final assignment = todoList[index];
                  return AssignmentCard(assignment: assignment);
                },
              ),
            ),
          ],
        ),
      ),
      const SizedBox(width: 36),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Done',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: doneList.length,
                itemBuilder: (context, index) {
                  final assignment = doneList[index];
                  return AssignmentCard(assignment: assignment);
                },
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
