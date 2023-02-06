import 'package:backpack/features/assignment_list/assignment_list.dart';
import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/firebase/firebase.dart';
import 'package:backpack/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final assignRepositoryProvider = Provider<AssignmentRepository>(
    (ref) => AssignmentRepository(FirebaseHelper(), ref));

// Contacts Firebase
class AssignmentRepository {
  AssignmentRepository(this.firebaseHelper, this.ref);

  final FirebaseHelper firebaseHelper;
  final Ref ref;

  UserProfile _getProfile() => ref.read(profileProvider.notifier).getProfile;

  void _setAssignments(List<Assignment> assignments) =>
      ref.read(assignListProvider.notifier).setAssignments(assignments);

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

  void createAssignment() {}

  void updateAssignment() {}

  void deleteAssignment() {}
}
