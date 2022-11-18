import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../firebase_helper.dart';
import '../model/app_user.dart';

final userProvider = StateNotifierProvider<UserNotifier, AppUser?>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<AppUser?> {
  UserNotifier() : super(null);

  Future<AppUser?> getUser() async {
    // See if user is logged in
    if (FirebaseAuth.instance.currentUser == null) {
      state = state;
    } else {
      // Update if they are logged in
      final String userId = FirebaseAuth.instance.currentUser!.uid;
      final user = await FirebaseHelper().readUser(userId);
      state = user;
    }

    return state;
  }

  Future<void> createUser(bool isTeacher) async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    final newUser = AppUser.empty();
    newUser.id = userId;
    newUser.isTeacher = isTeacher;
    await FirebaseHelper().insertUser(newUser);

    state = newUser;
  }

  Future<void> logOut() async {
    // Remove user and sign out
    await FirebaseAuth.instance.signOut();
    state = null;
  }

  Future<void> updateUser(AppUser user, [File? imageFile]) async {
    if (imageFile != null) {
      await uploadImage(imageFile);
      user.imageURL = await getImageURL(user.id);
    }

    await FirebaseHelper().updateUser(user);
    state = AppUser.empty();
    state = user;
  }

  Future<void> deleteUser() async {
    // Delete user entry from firestore database
    await FirebaseHelper().deleteUser(state!.id);
    // Sign out user and delete their account
    await FirebaseAuth.instance.currentUser?.delete();
    // Remove user from this provider
    state = null;
  }

  // Marks the specified assignment as complete
  Future<void> markComplete(String assignmentId) async {
    final updatedUser = state;
    updatedUser!.completed.add(assignmentId);
    await FirebaseHelper().updateUser(updatedUser);

    state = AppUser.empty();
    state = updatedUser;
  }

  // Upload profile picture
  Future uploadImage(File imageFile) async {
    final fileName = state!.id;
    final destination = 'profile_images/$fileName';

    // Create a storage reference from our app
    final ref = FirebaseStorage.instance.ref().child(destination);

    await ref.putFile(imageFile);
  }

  Future<String> getImageURL(String userId) async {
    final fileName = userId;
    final destination = 'profile_images/$fileName';

    // Create a storage reference from our app
    final ref = FirebaseStorage.instance.ref().child(destination);

    try {
      return await ref.getDownloadURL();
    } catch (e) {
      return '';
    }
  }
}
