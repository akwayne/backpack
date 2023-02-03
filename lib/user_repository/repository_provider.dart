part of 'user_repository.dart';

// Provider for the user repository
final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(
    FirebaseHelper(),
    AuthHelper(),
    StorageHelper(),
    ref,
  ),
);
