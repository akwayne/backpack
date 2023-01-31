class AppUser {
  String id;
  bool isTeacher;
  String firstName;
  String lastName;
  String school;
  String imageURL;
  List courses;
  List completed;

  AppUser({
    required this.id,
    required this.isTeacher,
    required this.firstName,
    required this.lastName,
    required this.school,
    required this.imageURL,
    required this.courses,
    required this.completed,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String id) {
    return AppUser(
      id: id,
      isTeacher: map['isTeacher'] as bool,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      school: map['school'] as String,
      imageURL: map['imageURL'] as String,
      courses: map['courses'] as List<dynamic>,
      completed: map['completed'] as List<dynamic>,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isTeacher': isTeacher,
      'firstName': firstName,
      'lastName': lastName,
      'school': school,
      'imageURL': imageURL,
      'courses': courses,
      'completed': completed,
    };
  }

  factory AppUser.empty() {
    return AppUser(
      id: '',
      isTeacher: false,
      firstName: '',
      lastName: '',
      school: '',
      imageURL: '',
      courses: [],
      completed: [],
    );
  }
}
