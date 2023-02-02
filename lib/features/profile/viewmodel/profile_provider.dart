import 'dart:io';

import 'package:backpack/user_repository/user_repository.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/user_detail.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, UserDetail>(
    (ref) => ProfileNotifier(ref.watch(userRepositoryProvider)));

class ProfileNotifier extends StateNotifier<UserDetail> {
  ProfileNotifier(this.repository) : super(UserDetail.empty());

  final UserRepository repository;

  // Set the current user to be read by UI
  set _currentUser(UserDetail userDetail) => state = userDetail;

  // Update user details for current user
  Future<void> updateUser({
    String? newDisplayName,
    String? newSchool,
    String? newEmail,
    String? newPassword,
    File? imageFile,
  }) async {
    final user = state;
    user.displayName = newDisplayName;
    user.school = newSchool;

    final updatedUser = await repository.updateUser(
      userDetail: user,
      newEmail: newEmail,
      newPassword: newPassword,
      imageFile: imageFile,
    );

    _currentUser = updatedUser.copy();
  }

  // // Marks the specified assignment as complete
  // Future<void> markComplete(String assignmentId) async {
  //   final updatedUser = state.props[0] as UserDetail;
  //   updatedUser.completed.add(assignmentId);

  //   updateUser(userData: updatedUser);

  //   // state = AuthSignedIn();

}
