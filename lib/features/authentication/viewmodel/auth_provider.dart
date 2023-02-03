import 'package:backpack/constants/constants.dart';
import 'package:backpack/routing/router.dart';
import 'package:backpack/user_service/user_service.dart';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'error_provider.dart';

part 'auth_state.dart';

/// Modifies authentication state
final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier(
          ref.watch(userServiceProvider),
          ref.watch(routerProvider),
          ref.read(errorProvider.notifier),
        ));

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(
    this.service,
    this.router,
    this.errorNotifier,
  ) : super(const AuthSignedOut());

  final UserService service;
  final GoRouter router;
  final AuthErrorNotifier errorNotifier;

  /// Check for signed in user and set them to current user
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

  /// Sign in a user
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    // Clear previous error messages
    errorNotifier.clearErrors();
    try {
      state = const AuthInProgress();
      await service.signIn(email: email, password: password);
      router.goNamed(RouteName.home);
      state = const AuthSignedIn();
      // On failure, display error message
    } on FirebaseAuthException catch (e) {
      state = const AuthSignedOut();
      errorNotifier.parseErrors(e);
    }
  }

  /// Sign out user
  Future<void> signOut() async {
    await service.signOut();
    router.goNamed(RouteName.login);
    state = const AuthSignedOut();
  }

  /// Create a new user account in firebase auth
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
      state = const AuthInProgress();
      await service.createUser(email: email, password: password);
      router.goNamed(RouteName.setup);
      state = const AuthSignedIn();
      // Display error message if account creation failed
    } on FirebaseAuthException catch (e) {
      state = const AuthSignedOut();
      errorNotifier.parseErrors(e);
    }
  }

  /// Set up user profile object for new account
  Future<void> setupUserProfile({
    required bool isTeacher,
    required String? displayName,
    required String? school,
  }) async {
    state = const AuthInProgress();
    await service.setupUserProfile(
        isTeacher: isTeacher, displayName: displayName, school: school);
    router.goNamed(RouteName.home);
    state = const AuthSignedIn();
  }

  /// Delete a user
  Future<void> deleteUser() async {
    await service.deleteUser();
    router.goNamed(RouteName.login);
    state = const AuthSignedOut();
  }
}
