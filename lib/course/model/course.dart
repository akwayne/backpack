import 'subject.dart';

class Course {
  String? courseId;
  String name;
  Subject subject;
  String teacher;
  String location;
  List<int> weekdayList;
  String time;

  Course({
    required this.courseId,
    required this.name,
    required this.subject,
    required this.teacher,
    required this.location,
    required this.weekdayList,
    required this.time,
  });

  factory Course.fromMap(Map<String, dynamic> map, String courseId) {
    // Translate subject id number into subject enum type
    // Subject ids are from Minnesota dept. of Education
    final String subjectString = map['subject'] as String;
    Subject subject;

    switch (subjectString) {
      case '05':
        subject = Subject.arts;
        break;
      case '01':
        subject = Subject.english;
        break;
      case '24':
        subject = Subject.foreignLanguage;
        break;
      case '02':
        subject = Subject.math;
        break;
      case '03':
        subject = Subject.science;
        break;
      case '04':
        subject = Subject.socialStudies;
        break;
      // Any other subject is default
      default:
        subject = Subject.none;
    }

    // Get course days from map
    List<int> weekdayList = [];
    for (int item in map['weekdayList']) {
      weekdayList.add(item);
    }

    return Course(
      courseId: courseId,
      name: map['name'] as String,
      subject: subject,
      teacher: map['teacher'] as String,
      location: map['location'] as String,
      weekdayList: weekdayList,
      time: map['time'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': courseId ?? '',
      'name': name,
      'subject': subject.name,
      'teacher': teacher,
      'location': location,
      'weekdayList': weekdayList,
      'time': time,
    };
  }

  // Creates a string with course's days
  String getWeekdayString() {
    List<String> stringList = [];

    for (int dayInt in weekdayList) {
      String dayString;
      switch (dayInt) {
        case 1:
          dayString = 'Monday';
          break;
        case 2:
          dayString = 'Tuesday';
          break;
        case 3:
          dayString = 'Wednesday';
          break;
        case 4:
          dayString = 'Thursday';
          break;
        case 5:
          dayString = 'Friday';
          break;
        default:
          dayString = '';
      }
      stringList.add(dayString);
    }
    return stringList.join(', ');
  }
}
