import 'package:firebase_auth/firebase_auth.dart';

class FireAuthHelper {
  FireAuthHelper() {
    auth = FirebaseAuth.instance;
  }
  late FirebaseAuth auth;

  User? get user => auth.currentUser;

  Future<User?> registerUser(
      {required String email, required String password}) async {
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
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
    return user;
  }
}
