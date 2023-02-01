import 'package:backpack/features/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthHelper {
  AuthHelper() {
    auth = FirebaseAuth.instance;
  }
  late FirebaseAuth auth;

  User? get user => auth.currentUser;

  Future<User?> registerUser({
    required String email,
    required String password,
  }) async {
    User? newUser;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      newUser = userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          print('Email is already in use');
          break;
        case 'invalid-email':
          print('Please enter a valid email');
          break;
        case 'weak-password':
          print('Password must be at least 6 characters');
          break;
        default:
          print('other error');
      }
    }
    return newUser;
  }

  Future<void> updateUser({
    required UserData userData,
    required String? newEmail,
    required String? newPassword,
  }) async {
    if (userData.displayName != null) {
      await user?.updateDisplayName(userData.displayName);
    }
    if (userData.photoUrl != null) {
      await user?.updatePhotoURL(userData.photoUrl);
    }

    if (newEmail != null) {
      await user?.updateEmail(newEmail);
    }
    if (newPassword != null) {
      await user?.updatePassword(newPassword);
    }
  }

  Future<User?> signIn(
      {required String email, required String password}) async {
    User? signInUser;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      signInUser = userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          break;
        case 'invalid-email':
          print('No user found for that email.');
          break;
        case 'wrong-password':
          print('Incorrect Password');
          break;
        default:
          print('other error');
      }
    }
    return signInUser;
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<void> deleteUser() async {
    await user?.delete();
  }
}
