import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/firebase/firebase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/assignment.dart';

final assignmentProvider =
    StateNotifierProvider<AssignmentNotifier, List<Assignment>>((ref) {
  return AssignmentNotifier();
});

class AssignmentNotifier extends StateNotifier<List<Assignment>> {
  AssignmentNotifier() : super([]);

  Future<List<Assignment>> getAssignments(UserProfile user) async {
    state.clear();

    return state;
  }

  Assignment getAssignmentFromId(String id) {
    final index = state.indexWhere((element) => element.id == id);
    return state[index];
  }

  List<Assignment> getCourseAssignments(String courseId) {
    final courseAssignments =
        state.where((element) => element.courseId == courseId).toList();
    return courseAssignments;
  }

  Future<void> createAssignment(
      Assignment newAssignment, UserProfile user) async {
    await FirebaseHelper().insertAssignment(newAssignment);
    await getAssignments(user);
  }

  Future<void> deleteAssignment(Assignment assignment, UserProfile user) async {
    await FirebaseHelper().deleteAssignment(assignment.id);
    await getAssignments(user);
  }
}
