const String googleClientId =
    '145055936994-es5rd65c8calrrvqrql7bdaa4i6d00aq.apps.googleusercontent.com';

class RouteName {
  static const home = 'home';
  static const login = 'login';
  static const register = 'register';
  static const setup = 'setup';
  static const profile = 'profile';
  static const profileUpdate = 'profileupdate';
  static const course = 'course';
  static const addAssignment = 'addassignment';
}

class SubjectString {
  static const arts = 'Arts';
  static const english = 'English';
  static const foreignLanguage = 'Foreign Language';
  static const math = 'Math';
  static const science = 'Science';
  static const socialStudies = 'Social Studies';
  static const defaultSubject = '';
}

// Asset paths
class AssetString {
  static const backpack = 'assets/backpack.png';
  static const supplies = 'assets/supplies.jpg';

  // Icons from https://icons8.com/
  static const artsIcon = 'assets/course_icons/color-swatch.png';
  static const englishIcon = 'assets/course_icons/open-book.png';
  static const foreignLanguageIcon = 'assets/course_icons/geography.png';
  static const mathIcon = 'assets/course_icons/sine.png';
  static const scienceIcon = 'assets/course_icons/physics.png';
  static const socialStudiesIcon = 'assets/course_icons/us-capitol.png';
  static const defaultSubjectIcon = 'assets/course_icons/pencil.png';
}

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
