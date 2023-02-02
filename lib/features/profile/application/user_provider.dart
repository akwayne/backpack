import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:backpack/features/authentication/authentication.dart';

final userProvider = StateProvider<UserDetail>((ref) {
  return UserDetail.none();
});
