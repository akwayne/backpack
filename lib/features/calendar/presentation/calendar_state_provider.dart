// Provider stores selected date on calendar
import 'package:flutter_riverpod/flutter_riverpod.dart';

final calendarStateProvider =
    StateProvider<DateTime>(((ref) => DateTime.now()));
