import 'dart:io';

import 'package:backpack/student/view/student_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

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
  final imagePicker = ImagePicker();
  File? imageFile;

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
  Widget build(BuildContext context, [bool mounted = true]) {
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
              GestureDetector(
                onTap: () async {
                  final image = await imagePicker.pickImage(
                    source: ImageSource.gallery,
                    requestFullMetadata: false,
                  );
                  setState(() {
                    if (image != null) imageFile = File(image.path);
                  });
                },
                child: StudentAvatar(
                  imageRadius: 60,
                  image: imageFile == null
                      ? NetworkImage(widget.student.imageURL)
                      : FileImage(imageFile!),
                ),
              ),
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
                    widget.student.firstName = txtFirstName.text;
                    widget.student.lastName = txtLastName.text;
                    widget.student.school = txtSchool.text;

                    // Update in provider and firebase
                    await ref
                        .read(studentProvider.notifier)
                        .updateUser(widget.student, imageFile);

                    // Go back to previous page
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                  child: const Text('Update')),
              ElevatedButton(
                onPressed: () {
                  ref.read(studentProvider.notifier).deleteUser();
                  Navigator.restorablePushNamedAndRemoveUntil(
                      context, '/login', (Route<dynamic> route) => false);
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
