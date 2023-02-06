import 'dart:io';

import 'package:backpack/features/authentication/authentication.dart';
import 'package:backpack/router/router.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../model/user_profile.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile>(
    (ref) => ProfileNotifier(
          ref.watch(userRepositoryProvider),
          ref.watch(routerProvider),
        ));

class ProfileNotifier extends StateNotifier<UserProfile> {
  ProfileNotifier(this.repository, this.router) : super(UserProfile.empty());

  final UserRepository repository;
  final GoRouter router;

  // Allow other providers to read current profile
  UserProfile get getProfile => state;

  // Set a user profile to the state
  set setProfile(UserProfile userProfile) => state = userProfile.copy();

  // Update profile for current user
  Future<void> updateUser({
    String? newDisplayName,
    String? newSchool,
    String? newEmail,
    String? newPassword,
    File? imageFile,
  }) async {
    final currentProfile = getProfile;
    currentProfile.displayName = newDisplayName;
    currentProfile.school = newSchool;

    await repository.updateUser(
      userProfile: currentProfile,
      newEmail: newEmail,
      newPassword: newPassword,
      imageFile: imageFile,
    );

    router.pop();
  }

  // // Marks the specified assignment as complete
  // Future<void> markComplete(String assignmentId) async {
  //   final updatedUser = state.props[0] as UserDetail;
  //   updatedUser.completed.add(assignmentId);

  //   updateUser(userData: updatedUser);

  //   // state = AuthSignedIn();
}
