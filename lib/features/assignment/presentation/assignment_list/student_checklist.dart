import 'package:backpack/features/assignment/assignment.dart';
import 'package:backpack/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentChecklist extends ConsumerWidget {
  const StudentChecklist({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Rebuild on assignment list state change
    ref.watch(assignmentServiceProvider);

    final todoList = ref
        .read(assignmentServiceProvider.notifier)
        .getChecklist(isDoneList: false);

    final doneList = ref
        .read(assignmentServiceProvider.notifier)
        .getChecklist(isDoneList: true);

    final deviceType = getDeviceType(MediaQuery.of(context));

    return deviceType == DeviceType.mobile
        ? _buildMobileView(context, todoList, doneList)
        : _buildTabletView(context, todoList, doneList);
  }

  Widget _buildMobileView(
    BuildContext context,
    List<Assignment> todoList,
    List<Assignment> doneList,
  ) {
    return ListView(
      children: <Widget>[
        Text(
          'Today\'s Work',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        AssignmentList(todoList),
        const SizedBox(height: 16.0),
        Text(
          'Done',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        AssignmentList(doneList),
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
          child: ListView(
            children: [
              Text(
                'Today\'s Work',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              AssignmentList(todoList),
            ],
          ),
        ),
        const SizedBox(width: 32.0),
        Expanded(
          child: ListView(
            children: [
              Text(
                'Done',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              AssignmentList(doneList),
            ],
          ),
        ),
      ],
    );
  }
}
