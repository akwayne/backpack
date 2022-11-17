import 'app_user.dart';

class Teacher {
  String id;
  String firstName;
  String lastName;
  String school;
  String imageURL;

  Teacher({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.school,
    required this.imageURL,
  });

  factory Teacher.fromMap(Map<String, dynamic> map, String id) {
    return Teacher(
      id: id,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      school: map['school'] as String,
      imageURL: map['imageURL'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'school': school,
      'imageURL': imageURL,
      'isTeacher': true,
    };
  }

  factory Teacher.empty() {
    return Teacher(
      id: '',
      firstName: '',
      lastName: '',
      school: '',
      imageURL: '',
    );
  }
}
