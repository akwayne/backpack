import 'package:backpack/components/components.dart';
import 'package:backpack/features/assignment/assignment.dart';
import 'package:backpack/features/auth/auth.dart';
import 'package:backpack/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddAssignment extends ConsumerStatefulWidget {
  const AddAssignment({super.key, required this.courseId});

  final String courseId;

  @override
  AddAssignmentState createState() => AddAssignmentState();
}

class AddAssignmentState extends ConsumerState<AddAssignment> {
  bool _submissionRequired = false;

  final _txtName = TextEditingController();
  final _txtInstructions = TextEditingController();

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    final controls = [
      CustomTextField(label: 'Assignment Title', controller: _txtName),
      CustomTextField(label: 'Instructions', controller: _txtInstructions),
    ];

    // User object for updating assignments displayed
    final user = ref.watch(authProvider) ?? UserData.empty();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => AppRouter.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: <Widget>[
                  Text(widget.courseId),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    primary: false,
                    itemCount: controls.length,
                    itemBuilder: (context, index) {
                      return controls[index];
                    },
                  ),
                  Switch(
                    value: _submissionRequired,
                    onChanged: (bool value) {
                      setState(() {
                        _submissionRequired = value;
                      });
                    },
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final newAssignment = Assignment(
                          id: '',
                          courseId: widget.courseId,
                          name: _txtName.text,
                          instructions: _txtInstructions.text,
                          submissionRequired: _submissionRequired,
                        );
                        await ref
                            .read(assignmentProvider.notifier)
                            .createAssignment(newAssignment, user);

                        if (!mounted) return;
                        AppRouter.pop(context);
                      },
                      child: const Text('Create Assignment'))
                ],
              )),
        ),
      ),
    );
  }
}
