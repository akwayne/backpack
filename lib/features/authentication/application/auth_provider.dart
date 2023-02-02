import 'package:backpack/constants/strings.dart';
import 'package:backpack/features/profile/profile.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../user_repository/user_repository.dart';
import 'error_provider.dart';

part 'auth_state.dart';

/// Reads and modifies authentication state
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
    (ref) => AuthNotifier(ref.watch(userRepositoryProvider), ref));

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this.repository, this.ref) : super(const AuthSignedOut());

  final UserRepository repository;
  final Ref ref;

  // Set the current user to be read by UI
  set _currentUser(UserDetail userDetail) =>
      ref.read(profileProvider.notifier).state = userDetail;

  // Check for signed in user and set them to current user
  Future<void> getUserDetail() async {
    UserDetail? userDetail = await repository.getCurrentUserDetail();
    if (userDetail == null) {
      state = const AuthSignedOut();
    } else {
      _currentUser = userDetail;
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
      if (password != confirmPassword) {
        throw FirebaseAuthException(code: ExceptionString.noPasswordMatch);
      }

      await repository.createUser(
        email: email,
        password: password,
      );
      state = const AuthInProgress();
    } on FirebaseAuthException catch (e) {
      ref.read(errorProvider.notifier).parseErrors(e);
    }
  }

  // Create new user detail object and set as current user
  Future<void> createUserDetail({
    required bool isTeacher,
    required String? displayName,
    required String? school,
  }) async {
    final newUserDetail = await repository.createUserDetail(
        isTeacher: isTeacher, displayName: displayName, school: school);
    _currentUser = newUserDetail;
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
      await repository.signIn(email: email, password: password);
      await getUserDetail();
    } on FirebaseAuthException catch (e) {
      ref.read(errorProvider.notifier).parseErrors(e);
    }
  }

  // Sign out a user
  Future<void> signOut() async {
    await repository.signOut();
    _currentUser = UserDetail.empty();
    state = const AuthSignedOut();
  }

  // Delete a user
  Future<void> deleteUser() async {
    await repository.deleteUser();
    _currentUser = UserDetail.empty();
    state = const AuthSignedOut();
  }
}
