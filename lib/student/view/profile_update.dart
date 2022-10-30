import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../firebase_helper.dart';
import '../model/student.dart';
import '../viewmodel/student_provider.dart';

class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({super.key, required this.student});

  final Student student;

  @override
  State<ProfileUpdate> createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  List<ProfileTextField> controls = [];
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtSchool = TextEditingController();
  final helper = FirebaseHelper();

  @override
  void initState() {
    controls = [
      ProfileTextField(label: 'First Name', controller: txtFirstName),
      ProfileTextField(label: 'Last Name', controller: txtLastName),
      ProfileTextField(label: 'School', controller: txtSchool),
    ];

    txtFirstName.text = widget.student.firstName;
    txtLastName.text = widget.student.lastName;
    txtSchool.text = widget.student.school;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Consumer(builder: (context, ref, child) {
        return SafeArea(
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
                  onPressed: () {
                    // Update fields in student object
                    widget.student.firstName = txtFirstName.text;
                    widget.student.lastName = txtLastName.text;
                    widget.student.school = txtSchool.text;

                    // Update in provider and firebase
                    ref
                        .read(studentProvider.notifier)
                        .updateUser(widget.student);

                    // Go back to previous page
                    Navigator.pop(context);
                  },
                  child: const Text('Update')),
              ElevatedButton(
                onPressed: () {
                  // ref.read(studentProvider.notifier).deleteUser();
                  // Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Delete Account'),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class ProfileTextField extends StatelessWidget {
  const ProfileTextField({
    super.key,
    required this.label,
    required this.controller,
  });

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: label,
            labelText: label),
      ),
    );
  }
}
