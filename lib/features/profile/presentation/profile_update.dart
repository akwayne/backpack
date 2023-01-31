import 'dart:io';

import 'package:backpack/components/components.dart';
import 'package:backpack/features/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

// Provider determines which view of the course page we are looking at
final imageUploadProvider = StateProvider<File?>((ref) => null);

class ProfileUpdate extends ConsumerWidget {
  const ProfileUpdate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref, [bool mounted = true]) {
    // User info to display
    final user = ref.watch(userProvider) ?? AppUser.empty();
    final currentImage =
        user.imageURL != '' ? NetworkImage(user.imageURL) : null;

    final txtFirstName = TextEditingController();
    final txtLastName = TextEditingController();
    final txtSchool = TextEditingController();

    final controls = [
      CustomTextField(label: 'First Name', controller: txtFirstName),
      CustomTextField(label: 'Last Name', controller: txtLastName),
      CustomTextField(label: 'School', controller: txtSchool),
    ];

    final imagePicker = ImagePicker();
    File? imageFile = ref.watch(imageUploadProvider);

    txtFirstName.text = user.firstName;
    txtLastName.text = user.lastName;
    txtSchool.text = user.school;

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
                    child: UserAvatar(
                      imageRadius: 60,
                      image: imageFile == null
                          ? currentImage
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
                                // Update fields in user object
                                user.firstName = txtFirstName.text;
                                user.lastName = txtLastName.text;
                                user.school = txtSchool.text;

                                // Update in provider and firebase
                                await ref
                                    .read(userProvider.notifier)
                                    .updateUser(user, imageFile);

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
                  TextButton(
                    onPressed: () {
                      // delete user
                      ref.read(userProvider.notifier).deleteUser();

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
