import 'package:intl/intl.dart';
import 'subject.dart';

class Course {
  String courseId;
  String name;
  Subject subject;
  // TODO: might not need teacher id here
  String teacherId;
  String teacherName;
  String location;
  List<int> weekdayList;
  String time;
  DateTime timeStamp;

  Course({
    required this.courseId,
    required this.name,
    required this.subject,
    required this.teacherId,
    required this.teacherName,
    required this.location,
    required this.weekdayList,
    required this.time,
    required this.timeStamp,
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

    // Get student ids from map
    List<String> students = [];
    for (String id in map['students']) {
      students.add(id);
    }

    return Course(
      courseId: courseId,
      name: map['name'] as String,
      subject: subject,
      teacherId: map['teacherId'] as String,
      teacherName: map['teacherName'] as String,
      location: map['location'] as String,
      weekdayList: weekdayList,
      time: map['time'] as String,
      timeStamp: DateTime.parse("2000-01-01 ${map['time'] as String}:00"),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'subject': subject.name,
      'teacherId': teacherId,
      'teacherName': teacherName,
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

  // Get course time in 12 hour clock instead of 24
  String getTimeString() {
    return DateFormat('jm').format(timeStamp);
  }
}
