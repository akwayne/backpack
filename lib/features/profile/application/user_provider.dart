import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:backpack/features/authorization/authorization.dart';

final userProvider = StateProvider<UserDetail>((ref) {
  return UserDetail.none();
});
