import 'dart:io';

import 'package:backpack/components/components.dart';
import 'package:backpack/features/authentication/authentication.dart';
import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/routing/routing.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// Stores image file being uploaded
final imageUploadProvider = StateProvider<File?>((ref) => null);

class ProfileUpdate extends ConsumerWidget {
  const ProfileUpdate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref, [bool mounted = true]) {
    final UserDetail user = ref.watch(profileProvider);

    final currentImage =
        (user.photoUrl != null) ? NetworkImage(user.photoUrl!) : null;

    final txtDisplayName = TextEditingController();
    final txtSchool = TextEditingController();

    final controls = [
      CustomTextField(label: 'Display Name', controller: txtDisplayName),
      CustomTextField(label: 'School', controller: txtSchool),
    ];

    txtDisplayName.text = user.displayName ?? '';
    txtSchool.text = user.school ?? '';

    final imagePicker = ImagePicker();
    File? imageFile = ref.watch(imageUploadProvider);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              // clear uploaded image when going back to previous page
              ref.read(imageUploadProvider.notifier).state = null;
              AppRouter.pop(context);
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
                                // Update profile
                                await ref
                                    .read(profileProvider.notifier)
                                    .updateUser(
                                      newDisplayName: txtDisplayName.text,
                                      newSchool: txtSchool.text,
                                      imageFile: imageFile,
                                    );

                                // clear updated image
                                ref.read(imageUploadProvider.notifier).state =
                                    null;

                                // Go back to previous page
                                if (!mounted) return;
                                AppRouter.pop(context);
                              },
                              child: const Text('Update')),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // clear updated image
                      ref.read(imageUploadProvider.notifier).state = null;
                      ref.read(authProvider.notifier).deleteUser();
                      AppRouter.goLogin(context);
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
