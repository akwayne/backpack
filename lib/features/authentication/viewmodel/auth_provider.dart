import 'package:backpack/constants/constants.dart';
import 'package:backpack/user_service/user_service.dart';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'error_provider.dart';

part 'auth_state.dart';

/// Modifies authentication state
final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier(
          ref.watch(userServiceProvider),
          ref.read(errorProvider.notifier),
        ));

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(
    this.service,
    this.errorNotifier,
  ) : super(const AuthSignedOut());

  final UserService service;
  final AuthErrorNotifier errorNotifier;

  // Check for signed in user and set them to current user
  Future<void> initialize() async {
    // Check for signed in user
    User? user = service.currentAuthUser;
    if (user == null) {
      state = const AuthSignedOut();
    } else {
      await service.loadUser();
      state = const AuthSignedIn();
    }
  }

  // Sign in a user
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    // Clear previous error messages
    errorNotifier.clearErrors();

    try {
      // Attempt to sign in
      await service.signIn(email: email, password: password);

      // If success, update state
      state = const AuthSignedIn();

      // On failure, display error message
    } on FirebaseAuthException catch (e) {
      errorNotifier.parseErrors(e);
    }
  }

  // Sign out a user
  Future<void> signOut() async {
    // Sign out user
    await service.signOut();

    // User is signed out
    state = const AuthSignedOut();
  }

  // Create a new user account in firebase auth
  Future<void> createUser({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // Clear previous error messages
    errorNotifier.clearErrors();

    try {
      // Check that passwords match
      if (password != confirmPassword) {
        throw FirebaseAuthException(code: ExceptionString.noPasswordMatch);
      }

      // Attempt user creation
      await service.createUser(
        email: email,
        password: password,
      );

      // On success can move on to account setup page
      state = const AuthInProgress();

      // Display error message if account creation failed
    } on FirebaseAuthException catch (e) {
      errorNotifier.parseErrors(e);
    }
  }

  // Set up new user profile object for new account
  Future<void> setupUserProfile({
    required bool isTeacher,
    required String? displayName,
    required String? school,
  }) async {
    // Create new user detail
    await service.setupUserProfile(
        isTeacher: isTeacher, displayName: displayName, school: school);

    // User is now signed in
    state = const AuthSignedIn();
  }

  // Delete a user
  Future<void> deleteUser() async {
    // Delete user in firebase
    await service.deleteUser();

    // User is signed out
    state = const AuthSignedOut();
  }
}
