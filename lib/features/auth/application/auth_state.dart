part of 'auth_provider.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class SignedOutState extends AuthState {
  const SignedOutState();

  @override
  List<Object?> get props => [];
}

class SignedInState extends AuthState {
  const SignedInState({required this.userData});

  final UserData userData;

  @override
  List<Object?> get props => [userData];
}
