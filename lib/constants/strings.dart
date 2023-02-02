const String googleClientId =
    '145055936994-es5rd65c8calrrvqrql7bdaa4i6d00aq.apps.googleusercontent.com';

// Firebase Auth Exception Codes
class ExceptionString {
  static const emailInUse = 'email-already-in-use';
  static const emailInUseMessage = 'Email is already in use';
  static const invalidEmail = 'invalid-email';
  static const invalidEmailMessage = 'Please enter a valid email';
  static const weakPassword = 'weak-password';
  static const weakPasswordMessage = 'Password must be at least 6 characters';
  static const userNotFound = 'user-not-found';
  static const userNotFoundMessage = 'No user found for that email';
  static const wrongPassword = 'wrong-password';
  static const wrongPasswordMessage = 'Incorrect password';

  // Custom exception codes
  static const noPasswordMatch = 'no-password-match';
  static const noPasswordMatchMessage = 'Passwords must match';
}

// Firebase Storage Paths
class FireStorePath {
  static const profileImages = 'profile_images/';
}
