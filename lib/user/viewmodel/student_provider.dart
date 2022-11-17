import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
      state = state;
    } else {
      // Update if they are logged in
      final String userId = FirebaseAuth.instance.currentUser!.uid;
      final student = await FirebaseHelper().readStudent(userId);
      state = student;
    }

    return state;
  }

  Future<void> createUser() async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    final newStudent = Student.empty();
    newStudent.id = userId;
    await FirebaseHelper().insertStudent(newStudent);

    state = newStudent;
  }

  Future<void> logOut() async {
    // Remove user and sign out
    await FirebaseAuth.instance.signOut();
    state = null;
  }

  Future<void> updateUser(Student student, [File? imageFile]) async {
    if (imageFile != null) {
      await uploadImage(imageFile);
      student.imageURL = await getImageURL(student.id);
    }

    await FirebaseHelper().updateStudent(student);
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
    final updatedStudent = state;
    updatedStudent!.completed.add(assignmentId);
    await FirebaseHelper().updateStudent(updatedStudent);

    state = Student.empty();
    state = updatedStudent;
  }

  // Upload profile picture
  Future uploadImage(File imageFile) async {
    final fileName = state!.id;
    final destination = 'profile_images/$fileName';

    // Create a storage reference from our app
    final ref = FirebaseStorage.instance.ref().child(destination);

    await ref.putFile(imageFile);
  }

  Future<String> getImageURL(String userId) async {
    final fileName = userId;
    final destination = 'profile_images/$fileName';

    // Create a storage reference from our app
    final ref = FirebaseStorage.instance.ref().child(destination);

    try {
      return await ref.getDownloadURL();
    } catch (e) {
      return '';
    }
  }
}
