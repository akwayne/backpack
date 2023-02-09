import 'package:backpack/components/components.dart';
import 'package:backpack/features/assignment/assignment.dart';
import 'package:backpack/features/course/course.dart';
import 'package:backpack/features/course/presentation/course_detail/course_title_row.dart';
import 'package:backpack/utilities/utilities.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../course_appbar.dart';
import 'teacher_assignments.dart';
import 'teacher_students.dart';
import 'teacher_submissions.dart';

class TeacherCourseView extends ConsumerWidget {
  const TeacherCourseView(this.course, {super.key});

  final Course course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navIndex = ref.watch(_navIndexProvider);

    void onIndexChange(int index) {
      // Update nav page
      ref.read(_navIndexProvider.notifier).state = index;
      // Close sub view
      ref.read(courseSubViewProvider.notifier).state = null;
    }

    final subViewId = ref.watch(courseSubViewProvider);

    return getDeviceType(MediaQuery.of(context)) == DeviceType.mobile
        ? _buildMobileView(navIndex, onIndexChange, subViewId)
        : _buildTabletView(navIndex, onIndexChange, subViewId);
  }

  Widget _buildMobileView(
    int navIndex,
    Function onIndexChange,
    String? subViewId,
  ) {
    final navPages = _buildNavPages(course, subViewId);

    return Scaffold(
      appBar: CourseAppBar(course, subViewId),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomFadeTransition(
            child: subViewId == null
                ? navPages[navIndex]['page']
                : navPages[navIndex]['subview'],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navIndex,
        onTap: (index) => onIndexChange(index),
        items: List.generate(
          navPages.length,
          (index) => BottomNavigationBarItem(
            icon: navPages[index]['icon'],
            label: navPages[index]['label'],
          ),
        ),
      ),
    );
  }

  Widget _buildTabletView(
    int navIndex,
    Function onIndexChange,
    String? subViewId,
  ) {
    final navPages = _buildNavPages(course, subViewId);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Row(
              children: [
                CustomNavRail(
                  selectedIndex: navIndex,
                  onTap: onIndexChange,
                  navPages: navPages,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 80),
                        Expanded(
                            child: Row(
                          children: [
                            Expanded(child: navPages[navIndex]['page']),
                            const SizedBox(width: 32.0),
                            Expanded(
                              child: navPages[navIndex]['subview'],
                            ),
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: CourseTitleRow(course: course),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _buildNavPages(
    Course course,
    String? subViewId,
  ) {
    return [
      {
        'page': TeacherCourseAssignments(course),
        'subview':
            (subViewId == null) ? Container() : AssignmentView(id: subViewId),
        'icon': const Icon(Icons.circle),
        'label': 'assignments',
      },
      {
        'page': TeacherCourseSubmissions(course),
        'subview': Container(),
        'icon': const Icon(Icons.circle),
        'label': 'submissions',
      },
      {
        'page': TeacherCourseStudents(course),
        'subview': Container(),
        'icon': const Icon(Icons.circle),
        'label': 'students',
      },
    ];
  }
}

final _navIndexProvider = StateProvider<int>((ref) => 0);
