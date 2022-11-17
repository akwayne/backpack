class Student {
  String id;
  String firstName;
  String lastName;
  String school;
  List completed;
  String imageURL;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.school,
    required this.completed,
    required this.imageURL,
  });

  factory Student.fromMap(Map<String, dynamic> map, String id) {
    return Student(
      id: id,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      school: map['school'] as String,
      completed: map['completed'] as List<dynamic>,
      imageURL: map['imageURL'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'school': school,
      'completed': completed,
      'imageURL': imageURL,
    };
  }

  factory Student.empty() {
    return Student(
      id: '',
      firstName: '',
      lastName: '',
      school: '',
      completed: [],
      imageURL: '',
    );
  }
}
