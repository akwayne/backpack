import 'package:backpack/user/view/auth/auth_text_field.dart';
import 'package:backpack/user/view/auth/login_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../model/student.dart';
import '../../viewmodel/student_provider.dart';

class SetupPage extends ConsumerWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref, [bool mounted = true]) {
    // Student info to display
    final student = ref.watch(studentProvider) ?? Student.empty();

    final txtFirstName = TextEditingController();
    final txtLastName = TextEditingController();
    final txtSchool = TextEditingController();

    return Scaffold(
      body: LoginBackground(
        child: ListView(
          children: [
            Text(
              'Finish creating your account',
              style: Theme.of(context).textTheme.headline5,
            ),
            AuthTextField(controller: txtFirstName, hintText: 'First Name'),
            const SizedBox(height: 8),
            AuthTextField(controller: txtLastName, hintText: 'Last Name'),
            const SizedBox(height: 8),
            AuthTextField(controller: txtSchool, hintText: 'School'),
            const SizedBox(height: 12),
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
