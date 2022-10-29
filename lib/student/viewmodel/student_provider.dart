import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../firebase_helper.dart';
import '../model/student.dart';

final studentProvider = StateNotifierProvider<StudentNotifier, Student?>((ref) {
  return StudentNotifier();
});

class StudentNotifier extends StateNotifier<Student?> {
  StudentNotifier() : super(null);

  Future<Student?> getUser() async {
    // See if user is logged in
    if (FirebaseAuth.instance.currentUser == null) {
      state = null;
    } else {
      final String userId = FirebaseAuth.instance.currentUser!.uid;
      final student = await FirebaseHelper().readStudent(userId);
      state = student;
    }

    return state;
  }

  Future<void> logOut() async {
    // Remove user and sign out
    await FirebaseAuth.instance.signOut();
    state = null;
  }

  // Marks the specified assignment as complete
  Future<void> markComplete(String assignmentId) async {
    final updatedStudent = state!;
    updatedStudent.completed.add(assignmentId);
    await FirebaseHelper().updateStudent(updatedStudent, state!.id);

    state = Student.empty();
    state = updatedStudent;
  }
}
