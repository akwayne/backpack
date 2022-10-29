class Student {
  String? id;
  String firstName;
  String lastName;
  String school;
  bool isDarkMode;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.school,
    required this.isDarkMode,
  });

  factory Student.fromMap(Map<String, dynamic> map, String id) {
    return Student(
      id: id,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      school: map['school'] as String,
      isDarkMode: map['isDarkMode'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'school': school,
      'isDarkMode': isDarkMode,
    };
  }

  factory Student.empty() {
    return Student(
      id: null,
      firstName: '',
      lastName: '',
      school: '',
      isDarkMode: false,
    );
  }
}
