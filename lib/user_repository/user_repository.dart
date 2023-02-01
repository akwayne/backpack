import 'dart:io';

import 'package:backpack/features/auth/auth.dart';
import 'package:backpack/firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firebaseHelper = FirebaseHelper();
  final authHelper = AuthHelper();
  return UserRepository(
    firebaseHelper: firebaseHelper,
    authHelper: authHelper,
  );
});

class UserRepository {
  UserRepository({
    required this.firebaseHelper,
    required this.authHelper,
  });

  final FirebaseHelper firebaseHelper;
  final AuthHelper authHelper;

  String? get currentUserId => authHelper.user?.uid;

  Future<UserData?> getUser() async {
    User? userAuth = authHelper.user;

    // if not logged in, return null
    if (userAuth == null) return null;

    Map<String, dynamic> databaseRow =
        await firebaseHelper.readUserData(userAuth.uid);

    return UserData.fromDatabase(
      map: databaseRow,
      id: userAuth.uid,
      displayName: userAuth.displayName,
      photoUrl: userAuth.photoURL,
    );
  }

  Future<UserData> createUser({
    required String email,
    required String password,
    required bool isTeacher,
  }) async {
    // Create user in firebase auth
    User? newUserAuth = await authHelper.registerUser(
      email: email,
      password: password,
    );
    // Create new userdata object
    final newUserData = UserData(
      id: newUserAuth!.uid,
      isTeacher: isTeacher,
      courses: [],
      completed: [],
    );
    // Insert database rows from userdata object
    await firebaseHelper.insertUserData(newUserData);

    return newUserData;
  }

  Future<UserData> updateUser(
      {required UserData userData,
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
      userData: userData,
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

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await authHelper.signIn(email: email, password: password);
  }

  Future<void> signOut() async {
    await authHelper.signOut();
  }

  Future deleteUser() async {
    await firebaseHelper.deleteUserData(currentUserId!);
    await authHelper.deleteUser();
  }
}
