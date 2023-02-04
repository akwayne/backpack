import 'package:backpack/user_service/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/assignment.dart';

final assignmentProvider =
    StateNotifierProvider<AssignmentNotifier, List<Assignment>>(
        (ref) => AssignmentNotifier(ref.watch(userServiceProvider)));

class AssignmentNotifier extends StateNotifier<List<Assignment>> {
  AssignmentNotifier(this.service) : super([]);

  final UserService service;

  // Set a list of assignments to the state
  set setAssignments(List<Assignment> assignments) =>
      state = [for (final assignment in assignments) assignment];

  // trigger repository to get assignments from firebase
  Future<void> getAssignments() async {
    await service.getAssignments();
  }

  void clearAssignments() {
    state.clear();
  }

  Assignment getAssignmentById(String id) {
    final index = state.indexWhere((element) => element.id == id);
    return state[index];
  }

  List<Assignment> getAssignmentsForCourse(String courseId) {
    return state.where((element) => element.courseId == courseId).toList();
  }

  // Future<void> createAssignment(
  //     Assignment newAssignment, UserProfile user) async {
  //   await FirebaseHelper().insertAssignment(newAssignment);
  //   await getAssignments(user);
  // }

  // Future<void> deleteAssignment(Assignment assignment, UserProfile user) async {
  //   await FirebaseHelper().deleteAssignment(assignment.id);
  //   await getAssignments(user);
  // }
}
