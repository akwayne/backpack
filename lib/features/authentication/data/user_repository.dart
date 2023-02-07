import 'dart:io';

import 'package:backpack/constants/constants.dart';
import 'package:backpack/features/assignment/assignment.dart';
import 'package:backpack/features/course/course.dart';
import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/firebase/firebase.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for the user repository
final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(
    ref.read(firebaseHelperProvider),
    ref.read(authHelperProvider),
    ref.read(storageHelperProvider),
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

  /// Return current signed in user or null
  User? get currentAuthUser => authHelper.user;

  /// Sign in to firebase auth with email and password
  /// Load user profile once user is signed in
  Future<void> signIn({required String email, required String password}) async {
    await authHelper.signIn(email: email, password: password);
    await loadUser();
  }

  /// Load user's profile from Firebase Database if they are signed in
  /// Load user's courses and assignments
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
    _setProfile(userProfile);
    await _loadCoursesAndAssignments();
  }

  Future<void> _setProfile(UserProfile userDetail) async =>
      ref.read(profileProvider.notifier).setProfile = userDetail;

  Future<void> _loadCoursesAndAssignments() async {
    await ref.read(courseRepositoryProvider).getCourses();
    await ref.read(assignRepositoryProvider).getAssignments();
  }

  /// Sign out active user
  /// Clear course and assignment details for this user from providers
  Future<void> signOut() async {
    await authHelper.signOut();
    _clearProviders();
  }

  void _clearProviders() {
    ref.read(assignmentServiceProvider.notifier).clearAssignments();
    ref.read(courseServiceProvider.notifier).clearCourses();
    ref.read(profileProvider.notifier).setProfile = UserProfile.empty();
  }

  /// Creates a new user account in Firebase Auth only
  Future<void> createUser(
      {required String email, required String password}) async {
    await authHelper.createUser(email: email, password: password);
  }

  /// Creates a profile for a new user account.
  /// Called during account setup.
  Future<void> setupUserProfile({
    required bool isTeacher,
    required String? displayName,
    required String? school,
  }) async {
    final newUserProfile = UserProfile(
      id: currentAuthUser!.uid,
      displayName: displayName,
      photoUrl: null,
      isTeacher: isTeacher,
      school: school,
      courses: [],
      completed: [],
    );
    await authHelper.updateUser(newDisplayName: displayName);
    await firebaseHelper.insertUserProfile(userProfile: newUserProfile);
    _setProfile(newUserProfile);
  }

  /// Updates the current user
  /// Sends updated profile to the profile provider
  Future<void> updateUser({
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
    _setProfile(updatedUser);
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
    await authHelper.deleteUser();
    _clearProviders();
  }
}
