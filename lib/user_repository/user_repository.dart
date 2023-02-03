import 'dart:io';

import 'package:backpack/constants/constants.dart';
import 'package:backpack/features/course/course.dart';
import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/firebase/firebase.dart';
import 'package:backpack/firebase/storage_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(
    FirebaseHelper(),
    AuthHelper(),
    StorageHelper(),
    ref,
  ),
);

/// Manages all user actions in firebase and firebase auth
class UserRepository {
  UserRepository(
    this.firebaseHelper,
    this.authHelper,
    this.storageHelper,
    this.ref,
  );

  final FirebaseHelper firebaseHelper;
  final AuthHelper authHelper;
  final StorageHelper storageHelper;
  final Ref ref;

  /// Return user if signed in, null if signed out
  User? get currentAuthUser => authHelper.user;

  // Get and set user detail from profile provider
  UserDetail get _getCurrentProfile =>
      ref.read(profileProvider.notifier).getProfile;
  void _setCurrentProfile(UserDetail userDetail) =>
      ref.read(profileProvider.notifier).setProfile = userDetail;

  Future<void> signIn({required String email, required String password}) async {
    await authHelper.signIn(email: email, password: password);
    // Once signed in, load user details
    await loadUser();
  }

  /// Load details for active user
  Future<void> loadUser() async {
    final user = currentAuthUser;
    if (user == null) return;

    Map<String, dynamic> databaseRow =
        await firebaseHelper.readUserDetail(user.uid);

    final userDetail = UserDetail.fromDatabase(
      row: databaseRow,
      id: user.uid,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );

    _setCurrentProfile(userDetail);
  }

  Future<void> signOut() async {
    await authHelper.signOut();
    // Remove user from profile provider
    _setCurrentProfile(UserDetail.empty());
  }

  /// Creates a new user account in firebase auth only
  Future<User?> createUser(
      {required String email, required String password}) async {
    return await authHelper.createUser(email: email, password: password);
  }

  /// Creates a user detail for a new user account.
  /// Called during account setup.
  Future<void> setupUserDetail({
    required bool isTeacher,
    required String? displayName,
    required String? school,
  }) async {
    // Create new user detail object
    final newUserDetail = UserDetail(
      id: currentAuthUser!.uid,
      displayName: displayName,
      photoUrl: null,
      isTeacher: isTeacher,
      school: school,
      courses: [],
      completed: [],
    );

    // store display name in firebase auth
    await authHelper.updateUser(newDisplayName: displayName);

    // create a database entry for the new user
    await firebaseHelper.insertUserDetail(userDetail: newUserDetail);

    _setCurrentProfile(newUserDetail);
  }

  /// Update an existing user
  Future<UserDetail> updateUser({
    required UserDetail userDetail,
    required String? newEmail,
    required String? newPassword,
    required File? imageFile,
  }) async {
    final updatedUser = userDetail;

    // Upload image if one is received
    if (imageFile != null) {
      final newPhotoUrl = await storageHelper.uploadFile(
        filename: updatedUser.id,
        path: FireStorePath.profileImages,
        file: imageFile,
      );
      updatedUser.photoUrl = newPhotoUrl;
    }

    // Update data in firebase auth
    await authHelper.updateUser(
      newDisplayName: updatedUser.displayName,
      newPhotoUrl: updatedUser.photoUrl,
      newEmail: newEmail,
      newPassword: newPassword,
    );

    // Update data in firebase database
    await firebaseHelper.updateUserDetail(updatedUser);

    return updatedUser;
  }

  Future<void> deleteUser() async {
    // Delete profile image file if user has one
    if (currentAuthUser!.photoURL != null) {
      await storageHelper.deleteFile(
          filename: currentAuthUser!.uid, path: FireStorePath.profileImages);
    }

    // Delete userdetail row in firebase
    await firebaseHelper.deleteUserDetail(currentAuthUser!.uid);

    // Remove user from profile provider
    _setCurrentProfile(UserDetail.empty());

    // Delete user in firebase auth
    await authHelper.deleteUser();
  }

  // Get course list for signed in user
  Future<List<Course>> getCourses() async {
    final userDetail = _getCurrentProfile;
    return await firebaseHelper.readCourses(userDetail.courses);
  }
}
