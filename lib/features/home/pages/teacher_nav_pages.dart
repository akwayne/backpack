part of 'home_page.dart';

final _teacherNavPages = <Map<String, dynamic>>[
  {
    'page': const CourseList(),
    'icon': const Icon(Icons.home),
    'label': 'home',
  },
  {
    'page': Container(),
    'icon': const Icon(Icons.class_),
    'label': 'my classes',
  },
  {
    'page': Container(),
    'icon': const Icon(Icons.calendar_today),
    'label': 'schedule',
  },
];
