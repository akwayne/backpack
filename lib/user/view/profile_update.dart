import 'dart:io';

import 'package:backpack/user/view/student_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../utilities/utilities.dart';
import '../model/student.dart';
import '../viewmodel/student_provider.dart';
import 'profile_text_field.dart';

// Provider determines which view of the course page we are looking at
final imageUploadProvider = StateProvider<File?>((ref) => null);

class ProfileUpdate extends ConsumerWidget {
  const ProfileUpdate({super.key});

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

    final imagePicker = ImagePicker();
    File? imageFile = ref.watch(imageUploadProvider);

    txtFirstName.text = student.firstName;
    txtLastName.text = student.lastName;
    txtSchool.text = student.school;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              // clear updated image
              ref.read(imageUploadProvider.notifier).state = null;
              context.pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final image = await imagePicker.pickImage(
                        source: ImageSource.gallery,
                        requestFullMetadata: false,
                      );
                      if (image != null) {
                        ref.read(imageUploadProvider.notifier).state =
                            File(image.path);
                      }
                    },
                    child: StudentAvatar(
                      imageRadius: 60,
                      image: imageFile == null
                          ? NetworkImage(student.imageURL)
                          : FileImage(imageFile),
                    ),
                  ),
                  SizedBox(
                    width: 450,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            primary: false,
                            itemCount: controls.length,
                            itemBuilder: (context, index) {
                              return controls[index];
                            },
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () async {
                                // Update fields in student object
                                student.firstName = txtFirstName.text;
                                student.lastName = txtLastName.text;
                                student.school = txtSchool.text;

                                // Update in provider and firebase
                                await ref
                                    .read(studentProvider.notifier)
                                    .updateUser(student, imageFile);

                                // clear updated image
                                ref.read(imageUploadProvider.notifier).state =
                                    null;

                                // Go back to previous page
                                if (!mounted) return;
                                context.pop();
                              },
                              child: const Text('Update')),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      // delete user
                      ref.read(studentProvider.notifier).deleteUser();

                      // clear updated image
                      ref.read(imageUploadProvider.notifier).state = null;

                      context.goNamed('login');
                    },
                    child: const Text(
                      'Delete Account',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
