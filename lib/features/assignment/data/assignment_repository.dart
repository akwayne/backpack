import 'dart:io';

import 'package:backpack/constants/src/strings.dart';
import 'package:backpack/features/assignment/assignment.dart';
import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/firebase/firebase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final assignRepositoryProvider =
    Provider<AssignmentRepository>((ref) => AssignmentRepository(
          ref.read(firebaseHelperProvider),
          ref.read(storageHelperProvider),
          ref,
        ));

// Contacts Firebase
class AssignmentRepository {
  AssignmentRepository(this.firebaseHelper, this.storageHelper, this.ref);

  final FirebaseHelper firebaseHelper;
  final StorageHelper storageHelper;
  final Ref ref;

  UserProfile _getProfile() => ref.read(profileProvider.notifier).getProfile;

  void _setProfile(UserProfile userDetail) =>
      ref.read(profileProvider.notifier).setProfile = userDetail;

  void _setAssignments(List<Assignment> assignments) =>
      ref.read(assignmentServiceProvider.notifier).setAssignments(assignments);

  /// Gets assignment list from Firebase to send to assignment provider
  Future<void> getAssignments() async {
    final userProfile = _getProfile();
    final assignments =
        await firebaseHelper.readAssignments(userProfile.courses);
    _setAssignments(assignments);
  }

  Future<void> submitAssignment({
    required Assignment assignment,
    required File? file,
  }) async {
    // Mark an assignment as complete
    final userProfile = _getProfile();
    userProfile.completed.add(assignment.id);
    await firebaseHelper.updateUserProfile(userProfile);
    _setProfile(userProfile);

    // Create Submission object

    // Upload submission file
    if (file != null) {
      await storageHelper.uploadFile(
          filename: userProfile.id,
          path:
              '${FireStorePath.submissions}${assignment.courseId}/${assignment.id}/',
          file: file);
    }
  }

  /// Returns active user's list of completed assginment ids
  List<String> getCompletedAssignmentList() {
    final userProfile = _getProfile();
    return userProfile.completed;
  }

  Future<void> createAssignment({required Assignment assignment}) async {
    await firebaseHelper.insertAssignment(assignment: assignment);
    await getAssignments();
  }

  void updateAssignment() {}

  Future<void> deleteAssignment({required Assignment assignment}) async {
    await firebaseHelper.deleteAssignment(assignmentId: assignment.id);
    await getAssignments();
  }
}
