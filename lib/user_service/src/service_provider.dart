part of 'service.dart';

// Provider for the user repository
final userServiceProvider = Provider<UserService>(
  (ref) => UserService(
    FirebaseHelper(),
    AuthHelper(),
    StorageHelper(),
    ref,
  ),
);
