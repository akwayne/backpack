part of 'auth_state_provider.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthSignedOut extends AuthState {
  const AuthSignedOut();

  @override
  List<Object?> get props => [];
}

class AuthInProgress extends AuthState {
  const AuthInProgress();

  @override
  List<Object?> get props => [];
}

class AuthSignedIn extends AuthState {
  const AuthSignedIn();

  @override
  List<Object?> get props => [];
}
