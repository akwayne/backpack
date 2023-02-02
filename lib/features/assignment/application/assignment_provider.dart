import 'package:backpack/features/profile/profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../firebase/firebase_helper.dart';
import '../domain/assignment.dart';

final assignmentProvider =
    StateNotifierProvider<AssignmentNotifier, List<Assignment>>((ref) {
  return AssignmentNotifier();
});

class AssignmentNotifier extends StateNotifier<List<Assignment>> {
  AssignmentNotifier() : super([]);

  Future<List<Assignment>> getAssignments(UserDetail user) async {
    state.clear();

    final assignmentList = await FirebaseHelper().readAssignments();

    state = assignmentList
        .where((assignment) => user.courses.contains(assignment.courseId))
        .toList();

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
      Assignment newAssignment, UserDetail user) async {
    await FirebaseHelper().insertAssignment(newAssignment);
    await getAssignments(user);
  }

  Future<void> deleteAssignment(Assignment assignment, UserDetail user) async {
    await FirebaseHelper().deleteAssignment(assignment.id);
    await getAssignments(user);
  }
}
