class Student {
  String id;
  String firstName;
  String lastName;
  String school;
  String imageURL;
  List completed;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.school,
    required this.imageURL,
    required this.completed,
  });

  factory Student.fromMap(Map<String, dynamic> map, String id) {
    return Student(
      id: id,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      school: map['school'] as String,
      imageURL: map['imageURL'] as String,
      completed: map['completed'] as List<dynamic>,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'school': school,
      'imageURL': imageURL,
      'completed': completed,
      'isTeacher': false,
    };
  }

  factory Student.empty() {
    return Student(
      id: '',
      firstName: '',
      lastName: '',
      school: '',
      imageURL: '',
      completed: [],
    );
  }
}
