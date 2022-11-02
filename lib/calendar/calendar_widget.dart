import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import 'calendar_page.dart';

// https://pub.dev/packages/table_calendar
// https://blog.logrocket.com/build-custom-calendar-flutter/

class CalendarWidget extends ConsumerWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime focusedDay = DateTime.now();
    final DateTime? selectedDay = ref.watch(calendarStateProvider);

    return TableCalendar(
      firstDay: _firstDay,
      lastDay: _lastDay,
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      onDaySelected: (selected, focused) {
        if (!isSameDay(selectedDay, selected)) {
          ref.read(calendarStateProvider.notifier).state = selected;
        }
      },
      calendarFormat: CalendarFormat.month,
      headerStyle: const HeaderStyle(formatButtonVisible: false),
      calendarStyle: CalendarStyle(
        weekendTextStyle: const TextStyle(color: Colors.grey),
        todayDecoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        selectedTextStyle:
            TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        todayTextStyle:
            TextStyle(color: Theme.of(context).colorScheme.onBackground),
      ),
    );
  }
}

// Set date range visible on calendar
final _today = DateTime.now();
final _firstDay = DateTime(_today.year, _today.month - 3, _today.day);
final _lastDay = DateTime(_today.year, _today.month + 3, _today.day);
