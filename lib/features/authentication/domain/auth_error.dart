class AuthError {
  AuthError({
    required this.emailError,
    required this.passwordError,
    required this.confirmPasswordError,
  });
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;

  factory AuthError.empty() {
    return AuthError(
      emailError: null,
      passwordError: null,
      confirmPasswordError: null,
    );
  }

  AuthError copyWith({
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
  }) {
    return AuthError(
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
      confirmPasswordError: confirmPasswordError ?? this.confirmPasswordError,
    );
  }
}
