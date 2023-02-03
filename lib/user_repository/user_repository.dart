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

  // Get current profile in profile provider
  UserDetail get _getCurrentProfile =>
      ref.read(profileProvider.notifier).getProfile;
  // Set new profile in profile provider
  Future<void> _setCurrentProfile(UserDetail userDetail) async =>
      ref.read(profileProvider.notifier).setProfile = userDetail;
  // Clear profile provider
  void _clearProfile() =>
      ref.read(profileProvider.notifier).setProfile = UserDetail.empty();

  void _setCourses(List<Course> courses) =>
      ref.read(courseProvider.notifier).setCourses = courses;
  void _clearCourses() => ref.read(courseProvider.notifier).clearCourses();

  // Clear assignment provider
  void _clearAssignments() {
    // TODO
  }

  // Sign in and load a user
  Future<void> signIn({required String email, required String password}) async {
    await authHelper.signIn(email: email, password: password);
    await loadUser();
  }

  // TODO get courses on load user
  /// Load details for active user
  Future<void> loadUser() async {
    final user = currentAuthUser;
    if (user == null) return;

    // get database row for the active user
    Map<String, dynamic> databaseRow =
        await firebaseHelper.readUserDetail(user.uid);

    final userDetail = UserDetail.fromDatabase(
      row: databaseRow,
      id: user.uid,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );

    // set the current user to profile provider
    _setCurrentProfile(userDetail);
  }

  Future<void> signOut() async {
    await authHelper.signOut();
    // Clear providers for this user
    _clearAssignments();
    _clearCourses();
    _clearProfile();
  }

  /// Create a new user account in firebase auth only
  Future<User?> createUser(
      {required String email, required String password}) async {
    return await authHelper.createUser(email: email, password: password);
  }

  /// Create a user detail for a new user account.
  /// Called during account setup.
  Future<void> setupUserDetail({
    required bool isTeacher,
    required String? displayName,
    required String? school,
  }) async {
    final newUserDetail = UserDetail(
      id: currentAuthUser!.uid,
      displayName: displayName,
      photoUrl: null,
      isTeacher: isTeacher,
      school: school,
      courses: [],
      completed: [],
    );

    // add display name to firebase auth
    await authHelper.updateUser(newDisplayName: displayName);

    // create a database entry for the new user
    await firebaseHelper.insertUserDetail(userDetail: newUserDetail);

    // send the new user detail to profile provider
    _setCurrentProfile(newUserDetail);
  }

  /// Update the current user and return updated details
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

  /// Delete and sign out current user
  Future<void> deleteUser() async {
    // Delete profile image file if user has one
    if (currentAuthUser!.photoURL != null) {
      await storageHelper.deleteFile(
          filename: currentAuthUser!.uid, path: FireStorePath.profileImages);
    }

    // Delete userdetail row in database
    await firebaseHelper.deleteUserDetail(currentAuthUser!.uid);

    // Clear providers for this user
    _clearAssignments();
    _clearCourses();
    _clearProfile();

    // Delete user in firebase auth
    await authHelper.deleteUser();
  }

  // Get course list and send to course provider
  Future<void> getCourses() async {
    final userDetail = _getCurrentProfile;
    final courses = await firebaseHelper.readCourses(userDetail.courses);
    _setCourses(courses);
  }
}
