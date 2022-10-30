import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../firebase_helper.dart';
import '../model/student.dart';

final studentProvider = StateNotifierProvider<StudentNotifier, Student>((ref) {
  return StudentNotifier();
});

class StudentNotifier extends StateNotifier<Student> {
  StudentNotifier() : super(Student.empty());

  Future<Student?> getUser() async {
    // See if user is logged in
    if (FirebaseAuth.instance.currentUser == null) {
      state = Student.empty();
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
    // state = null;
  }

  Future<void> updateUser(Student student) async {
    await FirebaseHelper().updateStudent(student, student.id);
    state = Student.empty();
    state = student;
  }

  Future<void> deleteUser() async {
    // Delete user entry from firestore database
    await FirebaseHelper().deleteStudent(state.id);

    // Sign out user and delete their account
    await FirebaseAuth.instance.currentUser?.delete();

    // Remove student from this provider
    state = Student.empty();
  }

  // Marks the specified assignment as complete
  Future<void> markComplete(String assignmentId) async {
    final updatedStudent = state;
    updatedStudent.completed.add(assignmentId);
    await FirebaseHelper().updateStudent(updatedStudent, state.id);

    state = Student.empty();
    state = updatedStudent;
  }

  // Updates student's theme preference
  Future<void> toggleTheme() async {
    final updatedStudent = state;
    updatedStudent.isDarkMode = !updatedStudent.isDarkMode;
    await FirebaseHelper().updateStudent(updatedStudent, state.id);

    state = Student.empty();
    state = updatedStudent;
  }

  // Upload profile picture
  Future uploadImage(File? imageFile) async {
    if (imageFile == null) return;

    final fileName = state.id;
    final destination = 'profile_images/$fileName';

    // Create a storage reference from our app
    final ref = FirebaseStorage.instance.ref().child(destination);

    await ref.putFile(imageFile);
  }

  Future<String> getImageURL() async {
    final fileName = state.id;
    final destination = 'profile_images/$fileName';

    // Create a storage reference from our app
    final ref = FirebaseStorage.instance.ref().child(destination);

    String url = '';
    try {
      url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      return url;
    }
  }
}
