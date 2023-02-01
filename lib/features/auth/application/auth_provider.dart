import 'dart:io';
import 'package:backpack/features/auth/auth.dart';
import 'package:backpack/user_repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'auth_state.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
    (ref) => AuthNotifier(ref.watch(userRepositoryProvider)));

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this.repository) : super(const SignedOutState());

  final UserRepository repository;

  Future<void> getUser() async {
    UserData? user = await repository.getUser();
    state =
        (user == null) ? const SignedOutState() : SignedInState(userData: user);
  }

  Future<void> createUser({
    required String email,
    required String password,
    required bool isTeacher,
  }) async {
    final newUser = await repository.createUser(
      email: email,
      password: password,
      isTeacher: isTeacher,
    );
    state = SignedInState(userData: newUser);
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await repository.signIn(email: email, password: password);
    await getUser();
  }

  Future<void> signOut() async {
    await repository.signOut();
    state = const SignedOutState();
  }

  Future<void> updateUser({
    required UserData userData,
    String? newEmail,
    String? newPassword,
    File? imageFile,
  }) async {
    final updatedUser = await repository.updateUser(
      userData: userData,
      newEmail: newEmail,
      newPassword: newPassword,
      imageFile: imageFile,
    );
    state = SignedInState(userData: updatedUser);
  }

  Future<void> deleteUser() async {
    await repository.deleteUser();
    state = const SignedOutState();
  }

  // TODO does this belong in assignment provider?
  // Marks the specified assignment as complete
  Future<void> markComplete(String assignmentId) async {
    final updatedUser = state.props[0] as UserData;
    updatedUser.completed.add(assignmentId);

    updateUser(userData: updatedUser);

    state = SignedInState(userData: updatedUser);
  }
}
