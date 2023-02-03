import 'dart:io';

import 'package:backpack/constants/constants.dart';
import 'package:backpack/features/assignment/assignment.dart';
import 'package:backpack/features/course/course.dart';
import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'repository_provider.dart';

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

  /// Return current signed in user or null
  User? get currentAuthUser => authHelper.user;

  // Interact with PROFILE PROVIDER
  UserProfile _getCurrentProfile() =>
      ref.read(profileProvider.notifier).getProfile;
  Future<void> _setCurrentProfile(UserProfile userDetail) async =>
      ref.read(profileProvider.notifier).setProfile = userDetail;
  void _clearProfile() =>
      ref.read(profileProvider.notifier).setProfile = UserProfile.empty();

  /// Sign in and load a user's profile
  Future<void> signIn({required String email, required String password}) async {
    await authHelper.signIn(email: email, password: password);
    await loadUser();
  }

  /// Load profile from database for active user
  Future<void> loadUser() async {
    final authUser = currentAuthUser;
    if (authUser == null) return;
    // get database row for the active user
    Map<String, dynamic> databaseRow =
        await firebaseHelper.readUserProfile(authUser.uid);
    // create new user profile with info from firebase auth and database row
    final userProfile = UserProfile.fromDatabase(
      row: databaseRow,
      id: authUser.uid,
      displayName: authUser.displayName,
      photoUrl: authUser.photoURL,
    );
    // set the current user to profile provider
    _setCurrentProfile(userProfile);
    // get courses for this user
    await getCourses();
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
  Future<void> setupUserProfile({
    required bool isTeacher,
    required String? displayName,
    required String? school,
  }) async {
    final newUserDetail = UserProfile(
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
    await firebaseHelper.insertUserProfile(userProfile: newUserDetail);
    // send the new user detail to profile provider
    _setCurrentProfile(newUserDetail);
  }

  /// Update the current user and return updated profile
  Future<UserProfile> updateUser({
    required UserProfile userProfile,
    required String? newEmail,
    required String? newPassword,
    required File? imageFile,
  }) async {
    final updatedUser = userProfile;
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
    await firebaseHelper.updateUserProfile(updatedUser);
    return updatedUser;
  }

  /// Delete and sign out current user
  Future<void> deleteUser() async {
    // Delete profile image file if user has one
    if (currentAuthUser!.photoURL != null) {
      await storageHelper.deleteFile(
          filename: currentAuthUser!.uid, path: FireStorePath.profileImages);
    }
    // Delete user row in database
    await firebaseHelper.deleteUserProfile(currentAuthUser!.uid);
    // Clear providers for this user
    _clearAssignments();
    _clearCourses();
    _clearProfile();
    // Delete user in firebase auth
    await authHelper.deleteUser();
  }

  // Interact with COURSE PROVIDER
  void _setCourses(List<Course> courses) =>
      ref.read(courseProvider.notifier).setCourses = courses;
  void _clearCourses() => ref.read(courseProvider.notifier).clearCourses();

  // Get course list and send to course provider
  Future<void> getCourses() async {
    final userProfile = _getCurrentProfile();
    final courses = await firebaseHelper.readCourses(userProfile.courses);
    _setCourses(courses);
  }

  // Interact with ASSIGNMENT PROVIDER
  void _setAssignments(List<Assignment> assignments) {}
  void _clearAssignments() {}

  // Get assignment list to send to assignment provider
  Future<void> getAssignments() async {
    final userProfile = _getCurrentProfile();
    final assignments =
        await firebaseHelper.readAssignments(userProfile.courses);
    _setAssignments(assignments);
  }
}
