import 'package:backpack/features/assignment/assignment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final assignmentServiceProvider =
    StateNotifierProvider<AssignmentServiceNotifier, List<Assignment>>(
        (ref) => AssignmentServiceNotifier(ref.read(assignRepositoryProvider)));

/// Stores a list of user's assignments as its state
class AssignmentServiceNotifier extends StateNotifier<List<Assignment>> {
  AssignmentServiceNotifier(this.repository) : super([]);

  final AssignmentRepository repository;

  // trigger repository to get assignments from firebase
  Future<void> getAssignments() async {
    await repository.getAssignments();
  }

  // Set a list of assignments to the state
  void setAssignments(List<Assignment> assignments) {
    state = [for (final assignment in assignments) assignment];
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
    required bool isDoneList,
    String? courseId,
  }) {
    final completed = repository.getCompletedAssignmentList();

    // get only assingments for a course if id was specified
    final assignments =
        (courseId != null) ? getAssignmentsForCourse(courseId) : state;

    if (isDoneList) {
      return assignments
          .where((element) => completed.contains(element.id))
          .toList();
    } else {
      return assignments
          .where((element) => !completed.contains(element.id))
          .toList();
    }
  }

  List<String> getCompletedAssignmentIds() {
    return repository.getCompletedAssignmentList();
  }

  // TODO create this function
  Future<void> markAssginmentComplete(String id) async {}

  Future<void> createAssignment(Assignment assignment) async {
    await repository.createAssignment(assignment: assignment);
  }

  void updateAssignment() {}

  Future<void> deleteAssignment(Assignment assignment) async {
    await repository.deleteAssignment(assignment: assignment);
  }
}
