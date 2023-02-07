import 'package:backpack/components/components.dart';
import 'package:backpack/features/course/course.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddAssignment extends ConsumerStatefulWidget {
  const AddAssignment(this.course, {super.key});

  final Course course;

  @override
  AddAssignmentState createState() => AddAssignmentState();
}

class AddAssignmentState extends ConsumerState<AddAssignment> {
  @override
  void initState() {
    super.initState();
  }

  final _txtName = TextEditingController();
  final _txtInstructions = TextEditingController();
  bool _submissionRequired = false;

  @override
  void dispose() {
    _txtName.dispose();
    _txtInstructions.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ListView(
              children: [
                Text(widget.course.id),
                CustomTextField(
                    controller: _txtName, label: 'Assignment Title'),
                CustomTextField(
                    controller: _txtInstructions, label: 'Instructions'),
                Switch(
                    value: _submissionRequired,
                    onChanged: (bool value) {
                      setState(() => _submissionRequired = value);
                    }),
                ElevatedButton(
                  // TODO create assignment
                  onPressed: () {},
                  child: const Text('Create Assignment'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
