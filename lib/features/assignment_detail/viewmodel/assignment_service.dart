import 'package:backpack/models/models.dart';
import 'package:backpack/repository/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final assignmentServiceProvider = Provider<AssignmentService>(
  (ref) => AssignmentService(ref.read(assignRepositoryProvider)),
);

class AssignmentService {
  AssignmentService(this.assignRepository);

  final AssignmentRepository assignRepository;

  List<String> getCompletedAssignmentIds() {
    return assignRepository.getCompletedAssignmentList();
  }

  void markAssginmentComplete() {}

  void createAssignment() {}

  void updateAssignment() {}

  void deleteAssignment() {}
}
