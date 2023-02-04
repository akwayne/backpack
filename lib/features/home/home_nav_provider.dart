import 'package:flutter_riverpod/flutter_riverpod.dart';

// Stores current home page tab
final homeNavIndexProvider = StateProvider<int>((ref) => 0);
