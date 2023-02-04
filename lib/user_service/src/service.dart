import 'dart:io';

import 'package:backpack/constants/constants.dart';
import 'package:backpack/features/assignment_list/assignment_list.dart';
import 'package:backpack/features/course_list/course_list.dart';
import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/firebase/firebase.dart';
import 'package:backpack/models/models.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'service_provider.dart';

/// Manages all user actions in firebase and firebase auth
class UserService {
  UserService(
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

  // Interact with PROFILE PROVIDER //
  UserProfile _getProfileProvider() =>
      ref.read(profileProvider.notifier).getProfile;
  Future<void> _setProfileProvider(UserProfile userDetail) async =>
      ref.read(profileProvider.notifier).setProfile = userDetail;
  void _clearProfileProvider() =>
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
    _setProfileProvider(userProfile);
    await getCourses();
    await getAssignments();
  }

  /// Refresh courses and assignments for active user
  Future<void> refreshUser() async {
    await getCourses();
    await getAssignments();
  }

  Future<void> signOut() async {
    _clearAssignments();
    _clearCourses();
    _clearProfileProvider();
    await authHelper.signOut();
  }

  /// Create a new user account in firebase auth only
  Future<void> createUser(
      {required String email, required String password}) async {
    await authHelper.createUser(email: email, password: password);
  }

  /// Create a user profile for a new user account.
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
    _setProfileProvider(newUserProfile);
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
    _clearAssignments();
    _clearCourses();
    _clearProfileProvider();
    await authHelper.deleteUser();
  }

  // Interact with COURSE PROVIDER
  void _setCourseProvider(List<Course> courses) =>
      ref.read(courseListProvider.notifier).setCourses = courses;
  void _clearCourses() => ref.read(courseListProvider.notifier).clearCourses();

  // Get course list and send to course provider
  Future<void> getCourses() async {
    final userProfile = _getProfileProvider();
    final courses = await firebaseHelper.readCourses(userProfile.courses);
    _setCourseProvider(courses);
  }

  // Interact with ASSIGNMENT PROVIDER
  void _setAssignmentProvider(List<Assignment> assignments) =>
      ref.read(assignListProvider.notifier).setAssignments = assignments;
  void _clearAssignments() =>
      ref.read(assignListProvider.notifier).clearAssignments();

  // Get assignment list to send to assignment provider
  Future<void> getAssignments() async {
    final userProfile = _getProfileProvider();
    final assignments =
        await firebaseHelper.readAssignments(userProfile.courses);
    _setAssignmentProvider(assignments);
  }
}