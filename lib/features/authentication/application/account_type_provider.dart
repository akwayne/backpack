import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountTypeProvider =
    StateNotifierProvider<AccountTypeNotifier, List<bool>>(
        (ref) => AccountTypeNotifier());

class AccountTypeNotifier extends StateNotifier<List<bool>> {
  AccountTypeNotifier() : super([true, false]);

  void selectStudent() {
    state = [true, false];
  }

  void selectTeacher() {
    state = [false, true];
  }
}
