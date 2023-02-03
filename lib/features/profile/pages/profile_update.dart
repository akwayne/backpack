import 'dart:io';

import 'package:backpack/components/components.dart';
import 'package:backpack/features/authentication/authentication.dart';
import 'package:backpack/features/profile/profile.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ProfileUpdate extends ConsumerStatefulWidget {
  const ProfileUpdate({Key? key}) : super(key: key);

  @override
  ProfileUpdateState createState() => ProfileUpdateState();
}

class ProfileUpdateState extends ConsumerState<ProfileUpdate> {
  @override
  void initState() {
    super.initState();
  }

  final _txtDisplayName = TextEditingController();
  final _txtSchool = TextEditingController();

  @override
  void dispose() {
    _txtDisplayName.dispose();
    _txtSchool.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProfile user = ref.watch(profileProvider);

    final currentImage =
        (user.photoUrl != null) ? NetworkImage(user.photoUrl!) : null;

    _txtDisplayName.text = user.displayName ?? '';
    _txtSchool.text = user.school ?? '';

    final imagePicker = ImagePicker();
    File? newImageFile;

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
                  GestureDetector(
                    onTap: () async {
                      final image = await imagePicker.pickImage(
                        source: ImageSource.gallery,
                        requestFullMetadata: false,
                      );
                      if (image != null) {
                        setState(() => newImageFile = File(image.path));
                      }
                    },
                    child: UserAvatar(
                      imageRadius: 60,
                      image: (newImageFile == null)
                          ? currentImage
                          : FileImage(newImageFile),
                    ),
                  ),
                  SizedBox(
                    width: 450,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _txtDisplayName,
                          label: 'Name',
                        ),
                        CustomTextField(
                          controller: _txtSchool,
                          label: 'School',
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () async => await ref
                                  .read(profileProvider.notifier)
                                  .updateUser(
                                    newDisplayName: _txtDisplayName.text,
                                    newSchool: _txtSchool.text,
                                    imageFile: newImageFile,
                                  ),
                              child: const Text('Update')),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        ref.read(authProvider.notifier).deleteUser(),
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
