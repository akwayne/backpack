import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthError {
  AuthError({
    required this.emailError,
    required this.passwordError,
  });
  final String? emailError;
  final String? passwordError;

  factory AuthError.none() {
    return AuthError(
      emailError: null,
      passwordError: null,
    );
  }

  AuthError copyWith({
    String? emailError,
    String? passwordError,
  }) {
    return AuthError(
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
    );
  }
}
