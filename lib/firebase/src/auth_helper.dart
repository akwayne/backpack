import 'package:firebase_auth/firebase_auth.dart';

class AuthHelper {
  AuthHelper() {
    auth = FirebaseAuth.instance;
  }
  late FirebaseAuth auth;

  /// Get the active user or null if not logged in
  User? get user => auth.currentUser;

  Future<void> signIn({required String email, required String password}) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<User?> createUser(
      {required String email, required String password}) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  Future<void> updateUser({
    String? newDisplayName,
    String? newPhotoUrl,
    String? newEmail,
    String? newPassword,
  }) async {
    if (newDisplayName != null) {
      await user?.updateDisplayName(newDisplayName);
    }
    if (newPhotoUrl != null) {
      await user?.updatePhotoURL(newPhotoUrl);
    }
    if (newEmail != null) {
      await user?.updateEmail(newEmail);
    }
    if (newPassword != null) {
      await user?.updatePassword(newPassword);
    }
  }

  Future<void> deleteUser() async {
    await user?.delete();
  }
}
