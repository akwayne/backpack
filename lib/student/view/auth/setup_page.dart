import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../model/student.dart';
import '../../viewmodel/student_provider.dart';
import '../profile_text_field.dart';

class SetupPage extends ConsumerWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref, [bool mounted = true]) {
    // Student info to display
    final student = ref.watch(studentProvider) ?? Student.empty();

    final txtFirstName = TextEditingController();
    final txtLastName = TextEditingController();
    final txtSchool = TextEditingController();

    final controls = [
      ProfileTextField(label: 'First Name', controller: txtFirstName),
      ProfileTextField(label: 'Last Name', controller: txtLastName),
      ProfileTextField(label: 'School', controller: txtSchool),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              primary: false,
              itemCount: controls.length,
              itemBuilder: (context, index) {
                return controls[index];
              },
            ),
            ElevatedButton(
              onPressed: () async {
                // Update fields in student object
                student.firstName = txtFirstName.text;
                student.lastName = txtLastName.text;
                student.school = txtSchool.text;

                // Update in provider and firebase
                await ref.read(studentProvider.notifier).updateUser(student);

                // Continue to Home
                if (!mounted) return;
                context.goNamed('home');
              },
              child: const Text('Finish'),
            ),
          ],
        ),
      ),
    );
  }
}
