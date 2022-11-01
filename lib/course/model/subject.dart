import 'package:flutter/material.dart';

import '../../utilities/utilities.dart';

enum Subject {
  arts,
  english,
  foreignLanguage,
  math,
  science,
  socialStudies,
  none,
}

extension SubjectExt on Subject {
  // Background color for each school subject
  Color get getColor {
    switch (this) {
      case Subject.arts:
        return ColorPalette.primary;
      case Subject.english:
        return ColorPalette.pink;
      case Subject.foreignLanguage:
        return ColorPalette.turquoise;
      case Subject.math:
        return ColorPalette.lightPrimary;
      case Subject.science:
        return ColorPalette.blue;
      case Subject.socialStudies:
        return ColorPalette.lightGold;
      default:
        return Colors.grey;
    }
  }

  // Images from https://icons8.com/
  String get getImage {
    switch (this) {
      case Subject.arts:
        return 'assets/course_icons/color-swatch.png';
      case Subject.english:
        return 'assets/course_icons/open-book.png';
      case Subject.foreignLanguage:
        return 'assets/course_icons/geography.png';
      case Subject.math:
        return 'assets/course_icons/sine.png';
      case Subject.science:
        return 'assets/course_icons/physics.png';
      case Subject.socialStudies:
        return 'assets/course_icons/us-capitol.png';
      default:
        return 'assets/course_icons/pencil.png';
    }
  }
}
