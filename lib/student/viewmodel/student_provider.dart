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
      // Update if they are logged in
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

  Future<void> updateUser(Student student) async {
    await FirebaseHelper().updateStudent(student, student.id);
    state = Student.empty();
    state = student;
  }

  Future<void> deleteUser() async {
    // Delete user entry from firestore database
    await FirebaseHelper().deleteStudent(state!.id);

    // Sign out user and delete their account
    await FirebaseAuth.instance.currentUser?.delete();

    // Remove student from this provider
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

  // Updates student's theme preference
  Future<void> toggleTheme() async {
    final updatedStudent = state!;
    updatedStudent.isDarkMode = !updatedStudent.isDarkMode;
    await FirebaseHelper().updateStudent(updatedStudent, state!.id);

    state = Student.empty();
    state = updatedStudent;
  }
}
