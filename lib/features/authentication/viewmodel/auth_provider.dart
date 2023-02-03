import 'package:backpack/constants/constants.dart';
import 'package:backpack/user_repository/user_repository.dart';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'error_provider.dart';

part 'auth_state.dart';

/// Modifies authentication state
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
    (ref) => AuthNotifier(ref.watch(userRepositoryProvider), ref));

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this.repository, this.ref) : super(const AuthSignedOut());

  final UserRepository repository;
  final Ref ref;

  // Check for signed in user and set them to current user
  Future<void> checkAuthState() async {
    // Check for signed in user
    User? user = repository.currentAuthUser;
    if (user == null) {
      state = const AuthSignedOut();
    } else {
      await repository.loadUser();
      state = const AuthSignedIn();
    }
  }

  // Create a new user account in firebase auth
  Future<void> createUser({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // Clear previous error messages
    ref.read(errorProvider.notifier).clearErrors();

    try {
      // Check that passwords match
      if (password != confirmPassword) {
        throw FirebaseAuthException(code: ExceptionString.noPasswordMatch);
      }

      // Attempt user creation
      await repository.createUser(
        email: email,
        password: password,
      );

      // On success can move on to account setup page
      state = const AuthInProgress();

      // Display error message if account creation failed
    } on FirebaseAuthException catch (e) {
      ref.read(errorProvider.notifier).parseErrors(e);
    }
  }

  // Set up new user detail object for new account
  Future<void> setupUserDetail({
    required bool isTeacher,
    required String? displayName,
    required String? school,
  }) async {
    // Create new user detail
    await repository.setupUserDetail(
        isTeacher: isTeacher, displayName: displayName, school: school);

    // User is now signed in
    state = const AuthSignedIn();
  }

  // Sign in a user
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    // Clear previous error messages
    ref.read(errorProvider.notifier).clearErrors();

    try {
      // Attempt to sign in
      await repository.signIn(email: email, password: password);

      // If success, update state
      state = const AuthSignedIn();

      // On failure, display error message
    } on FirebaseAuthException catch (e) {
      ref.read(errorProvider.notifier).parseErrors(e);
    }
  }

  // Sign out a user
  Future<void> signOut() async {
    // Sign out user
    await repository.signOut();

    // User is signed out
    state = const AuthSignedOut();
  }

  // Delete a user
  Future<void> deleteUser() async {
    // Delete user in firebase
    await repository.deleteUser();

    // User is signed out
    state = const AuthSignedOut();
  }
}
