import 'dart:io';

import 'package:backpack/user_repository/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/user_detail.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, UserDetail>(
    (ref) => ProfileNotifier(ref.watch(userRepositoryProvider)));

class ProfileNotifier extends StateNotifier<UserDetail> {
  ProfileNotifier(this.repository) : super(UserDetail.empty());

  final UserRepository repository;

  // Get current user
  UserDetail get getProfile => state;
  // Set the current user to be read by UI
  set setProfile(UserDetail userDetail) => state = userDetail.copy();

  // Update user details for current user
  Future<void> updateUser({
    String? newDisplayName,
    String? newSchool,
    String? newEmail,
    String? newPassword,
    File? imageFile,
  }) async {
    final currentProfile = state;
    currentProfile.displayName = newDisplayName;
    currentProfile.school = newSchool;

    final updatedUser = await repository.updateUser(
      userDetail: currentProfile,
      newEmail: newEmail,
      newPassword: newPassword,
      imageFile: imageFile,
    );

    state = updatedUser.copy();
  }

  // // Marks the specified assignment as complete
  // Future<void> markComplete(String assignmentId) async {
  //   final updatedUser = state.props[0] as UserDetail;
  //   updatedUser.completed.add(assignmentId);

  //   updateUser(userData: updatedUser);

  //   // state = AuthSignedIn();

}
