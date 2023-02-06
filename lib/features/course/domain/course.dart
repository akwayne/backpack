import 'package:intl/intl.dart';
import 'subject.dart';

class Course {
  final String id;
  final String name;
  final Subject subject;
  final String teacherId;
  final String teacherName;
  final String location;
  final List<int> weekdayList;
  final String time;
  final DateTime timeStamp;

  Course({
    required this.id,
    required this.name,
    required this.subject,
    required this.teacherId,
    required this.teacherName,
    required this.location,
    required this.weekdayList,
    required this.time,
    required this.timeStamp,
  });

  factory Course.fromDatabase(Map<String, dynamic> row, String id) {
    return Course(
      id: id,
      name: row['name'] as String,
      subject: Subject.getSubjectFromId(row['subject']),
      teacherId: row['teacherId'] as String,
      teacherName: row['teacherName'] as String,
      location: row['location'] as String,
      weekdayList: List.castFrom(row['weekdayList']),
      time: row['time'] as String,
      timeStamp: DateTime.parse("2000-01-01 ${row['time'] as String}:00"),
    );
  }

  // Course Id not included in the map
  Map<String, dynamic> toDatabase() {
    return <String, dynamic>{
      'name': name,
      'subject': subject.id,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'location': location,
      'weekdayList': weekdayList,
      'time': time,
    };
  }

  // Creates a string with course's days
  String get getWeekdayString {
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
  String get getTimeString {
    return DateFormat('jm').format(timeStamp);
  }
}
