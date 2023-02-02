import 'dart:io';

import 'package:backpack/features/authentication/authentication.dart';
import 'package:backpack/firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firebaseHelper = FirebaseHelper();
  final authHelper = AuthHelper();
  return AuthRepository(
    firebaseHelper: firebaseHelper,
    authHelper: authHelper,
  );
});

class AuthRepository {
  AuthRepository({
    required this.firebaseHelper,
    required this.authHelper,
  });

  final FirebaseHelper firebaseHelper;
  final AuthHelper authHelper;

  // getter for current user id only
  String get currentUserId => authHelper.user!.uid;

  Future<UserDetail?> getCurrentUserDetail() async {
    User? user = authHelper.user;

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

  Future<void> deleteUser() async {
    await authHelper.deleteUser();
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

  // Unfinished

  // Future<UserData> createUser({
  //   required String email,
  //   required String password,
  //   required bool isTeacher,
  // }) async {
  //   // Create user in firebase auth
  //   User? newUserAuth = await authHelper.createUser(
  //     email: email,
  //     password: password,
  //   );
  //   // Create new userdata object
  //   final newUserData = UserData(
  //     id: newUserAuth!.uid,
  //     isTeacher: isTeacher,
  //     courses: [],
  //     completed: [],
  //   );
  //   // Insert database rows from userdata object
  //   await firebaseHelper.insertUserData(newUserData);

  //   return newUserData;
  // }

  // Future deleteUser() async {
  //   await firebaseHelper.deleteUserData(currentUserId!);
  //   await authHelper.deleteUser();
  // }

  Future<UserDetail> updateUser(
      {required UserDetail userData,
      required String? newEmail,
      required String? newPassword,
      required File? imageFile}) async {
    // Check for image file and upload first
    if (imageFile != null) {
      final newPhotoUrl = await uploadPhoto(
        id: userData.id,
        imageFile: imageFile,
      );
      userData.photoUrl = newPhotoUrl;
    }

    // Update user in firebase auth
    await authHelper.updateUser(
      newDisplayName: userData.displayName,
      newPhotoUrl: userData.photoUrl,
      newEmail: newEmail,
      newPassword: newPassword,
    );

    // Update database fields for this user
    await firebaseHelper.updateUserData(userData);

    return userData;
  }

  Future<String> uploadPhoto({
    required String id,
    required File imageFile,
  }) async {
    final fileName = id;
    final destination = 'profile_images/$fileName';

    // Create storage reference
    final ref = FirebaseStorage.instance.ref().child(destination);

    // Upload photo
    await ref.putFile(imageFile);

    // Return image url
    return await ref.getDownloadURL();
  }
}
