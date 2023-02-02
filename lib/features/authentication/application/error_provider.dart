import 'package:backpack/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/auth_error.dart';

final errorProvider = StateNotifierProvider<AuthErrorNotifier, AuthError>(
    (ref) => AuthErrorNotifier());

class AuthErrorNotifier extends StateNotifier<AuthError> {
  AuthErrorNotifier() : super(AuthError.empty());

  void clearErrors() {
    state = AuthError.empty();
  }

  void parseErrors(FirebaseAuthException error) {
    switch (error.code) {
      case ExceptionString.userNotFound:
        _addEmailError(ExceptionString.userNotFoundMessage);
        break;
      case ExceptionString.invalidEmail:
        _addEmailError(ExceptionString.invalidEmailMessage);
        break;
      case ExceptionString.emailInUse:
        _addEmailError(ExceptionString.emailInUseMessage);
        break;
      case ExceptionString.wrongPassword:
        _addPasswordError(ExceptionString.wrongPasswordMessage);
        break;
      case ExceptionString.weakPassword:
        _addPasswordError(ExceptionString.weakPasswordMessage);
        break;
      case ExceptionString.noPasswordMatch:
        _addConfirmPasswordError(ExceptionString.noPasswordMatchMessage);
        break;
      default:
        _addEmailError('Other Error');
    }
  }

  void _addEmailError(String errorMessage) {
    final newError = state;
    state = newError.copyWith(emailError: errorMessage);
  }

  void _addPasswordError(String errorMessage) {
    final newError = state;
    state = newError.copyWith(passwordError: errorMessage);
  }

  void _addConfirmPasswordError(String errorMessage) {
    final newError = state;
    state = newError.copyWith(confirmPasswordError: errorMessage);
  }
}
