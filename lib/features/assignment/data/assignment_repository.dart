import 'package:backpack/features/assignment/assignment.dart';
import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/firebase/firebase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final assignRepositoryProvider = Provider<AssignmentRepository>(
    (ref) => AssignmentRepository(ref.read(firebaseHelperProvider), ref));

// Contacts Firebase
class AssignmentRepository {
  AssignmentRepository(this.firebaseHelper, this.ref);

  final FirebaseHelper firebaseHelper;
  final Ref ref;

  UserProfile _getProfile() => ref.read(profileProvider.notifier).getProfile;

  void _setAssignments(List<Assignment> assignments) =>
      ref.read(assignmentServiceProvider.notifier).setAssignments(assignments);

  /// Gets assignment list from Firebase to send to assignment provider
  Future<void> getAssignments() async {
    final userProfile = _getProfile();
    final assignments =
        await firebaseHelper.readAssignments(userProfile.courses);
    _setAssignments(assignments);
  }

  /// Returns active user's list of completed assginment ids
  List<String> getCompletedAssignmentList() {
    final userProfile = _getProfile();
    return userProfile.completed;
  }

  void markAssignmentComplete() {}

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
