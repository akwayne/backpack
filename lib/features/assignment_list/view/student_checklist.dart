import 'package:backpack/models/models.dart';
import 'package:backpack/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/assign_list_provider.dart';
import 'assignment_list.dart';

class StudentChecklist extends ConsumerWidget {
  const StudentChecklist({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Rebuild on assignment list state change
    ref.watch(assignListProvider);

    final todoList =
        ref.read(assignListProvider.notifier).getChecklist(isDoneList: false);

    final doneList =
        ref.read(assignListProvider.notifier).getChecklist(isDoneList: true);

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today\'s Work',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              AssignmentList(todoList),
            ],
          ),
        ),
        Expanded(
          child: Column(
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
