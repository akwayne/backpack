import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/user_service/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/src/assignment.dart';

final assignListProvider =
    StateNotifierProvider<AssignListNotifier, List<Assignment>>(
        (ref) => AssignListNotifier(ref.watch(userServiceProvider)));

class AssignListNotifier extends StateNotifier<List<Assignment>> {
  AssignListNotifier(this.service) : super([]);

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

  List<Assignment> getChecklist({
    required UserProfile user,
    required bool isDoneList,
    String? courseId,
  }) {
    // get only assingments for a course if id was specified
    final assignments =
        (courseId != null) ? getAssignmentsForCourse(courseId) : state;

    if (isDoneList) {
      return assignments
          .where((element) => user.completed.contains(element.id))
          .toList();
    } else {
      return assignments
          .where((element) => !user.completed.contains(element.id))
          .toList();
    }
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
