import 'dart:io';

import 'package:backpack/user_repository/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/user_profile.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile>(
    (ref) => ProfileNotifier(ref.watch(userRepositoryProvider)));

class ProfileNotifier extends StateNotifier<UserProfile> {
  ProfileNotifier(this.repository) : super(UserProfile.empty());

  final UserRepository repository;

  // Allow repository to get current user profile
  UserProfile get getProfile => state;
  // Set the current user profile to the state
  set setProfile(UserProfile userProfile) => state = userProfile.copy();

  // Update profile for current user
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
      userProfile: currentProfile,
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