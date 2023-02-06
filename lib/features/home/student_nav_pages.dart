part of 'home_page.dart';

final _studentNavPages = <Map<String, dynamic>>[
  {
    'page': const StudentChecklist(),
    'icon': const Icon(Icons.check_circle_outline),
    'label': 'home',
  },
  {
    'page': const CourseList(),
    'icon': const Icon(Icons.class_),
    'label': 'my classes',
  },
  {
    'page': Container(),
    'icon': const Icon(Icons.calendar_today),
    'label': 'schedule',
  },
];
