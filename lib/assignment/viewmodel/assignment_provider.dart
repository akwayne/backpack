import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../firebase_helper.dart';
import '../model/assignment.dart';

final assignmentProvider =
    StateNotifierProvider<AssignmentNotifier, List<Assignment>>((ref) {
  return AssignmentNotifier();
});

class AssignmentNotifier extends StateNotifier<List<Assignment>> {
  AssignmentNotifier() : super([]);

  // TODO update more often than just when app opens
  Future<List<Assignment>> getAssignments() async {
    if (state.isEmpty) {
      final assignmentList = await FirebaseHelper().readAssignments();
      state.addAll(assignmentList);
    }
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
}
