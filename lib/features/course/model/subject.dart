import 'package:backpack/constants/constants.dart';
import 'package:flutter/material.dart';

class Subject {
  Subject(this.id, this.name, this.image, this.color);

  final String id;
  final String name;
  final String image;
  final Color color;

  factory Subject.getSubjectFromId(String id) {
    return subjects.firstWhere((element) => element.id == id);
  }

  // Subject ids are from Minnesota dept. of Education
  static final subjects = [
    Subject(
      '05',
      SubjectString.arts,
      AssetString.artsIcon,
      AppColors.primary,
    ),
    Subject(
      '01',
      SubjectString.english,
      AssetString.englishIcon,
      AppColors.pink,
    ),
    Subject(
      '24',
      SubjectString.foreignLanguage,
      AssetString.foreignLanguageIcon,
      AppColors.turquoise,
    ),
    Subject(
      '02',
      SubjectString.math,
      AssetString.mathIcon,
      AppColors.lightPrimary,
    ),
    Subject(
      '03',
      SubjectString.science,
      AssetString.scienceIcon,
      AppColors.blue,
    ),
    Subject(
      '04',
      SubjectString.socialStudies,
      AssetString.socialStudiesIcon,
      AppColors.lightGold,
    ),
    Subject(
      '00',
      SubjectString.defaultSubject,
      AssetString.defaultSubjectIcon,
      Colors.grey,
    ),
  ];
}
