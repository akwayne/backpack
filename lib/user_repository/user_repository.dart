import 'dart:io';

import 'package:backpack/constants/constants.dart';
import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/firebase/firebase.dart';
import 'package:backpack/firebase/storage_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firebaseHelper = FirebaseHelper();
  final authHelper = AuthHelper();
  final storageHelper = StorageHelper();
  return UserRepository(
    firebaseHelper: firebaseHelper,
    authHelper: authHelper,
    storageHelper: storageHelper,
  );
});

/// Manages all user actions in firebase and firebase auth
class UserRepository {
  UserRepository({
    required this.firebaseHelper,
    required this.authHelper,
    required this.storageHelper,
  });

  final FirebaseHelper firebaseHelper;
  final AuthHelper authHelper;
  final StorageHelper storageHelper;

  /// Get the active user or null if not logged in
  User? get currentUser => authHelper.user;

  /// Get for current user ID only
  String get currentUserId => authHelper.user!.uid;

  /// Get user detail for active user
  Future<UserDetail?> getCurrentUserDetail() async {
    final user = currentUser;
    // if not logged in, return null
    if (user == null) return null;

    Map<String, dynamic> databaseRow =
        await firebaseHelper.readUserDetail(user.uid);

    return UserDetail.fromDatabase(
      map: databaseRow,
      id: user.uid,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    await authHelper.signIn(email: email, password: password);
  }

  Future<void> signOut() async {
    await authHelper.signOut();
  }

  Future<User?> createUser(
      {required String email, required String password}) async {
    return await authHelper.createUser(email: email, password: password);
  }

  Future<UserDetail> createUserDetail({
    required bool isTeacher,
    required String? displayName,
    required String? school,
  }) async {
    // Create new user detail object
    final newUserDetail = UserDetail(
      id: currentUserId,
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

    return newUserDetail;
  }

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

    // Update data in firebase
    await firebaseHelper.updateUserDetail(updatedUser);

    return updatedUser;
  }

  Future<void> deleteUser() async {
    // Delete profile image file if user has one
    if (currentUser!.photoURL != null) {
      await storageHelper.deleteFile(
          filename: currentUserId, path: FireStorePath.profileImages);
    }

    // Delete userdetail row in firebase
    await firebaseHelper.deleteUserDetail(currentUserId);

    // Delete user in firebase auth
    await authHelper.deleteUser();
  }
}
