import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

// Defines main font for app
const String _appFont = 'Poppins';

class AppTheme {
  // Defines Light theme for app
  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: _appFont,
      textTheme: textThemeLight(),
      appBarTheme: appBarThemeLight(),
      colorScheme: const ColorScheme.light(
        primary: AppColors.darkPrimary,
        primaryContainer: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.turquoise,
      ),
      scaffoldBackgroundColor: AppColors.background,
      elevatedButtonTheme: customButtonTheme(),
      toggleButtonsTheme: customToggleButtonsTheme(),
    );
  }

  // Defines Dark theme for app
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: _appFont,
      appBarTheme: appBarThemeDark(),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        primaryContainer: AppColors.lightPrimary,
        onPrimary: Colors.black87,
        secondary: AppColors.lightTurquoise,
      ),
      elevatedButtonTheme: customButtonTheme(),
      toggleButtonsTheme: customToggleButtonsTheme(),
    );
  }

  static TextTheme textThemeLight() {
    return const TextTheme(
      headlineMedium: TextStyle(
        color: Colors.black87,
      ),
    );
  }

  static AppBarTheme appBarThemeLight() {
    return const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      // Must specify text and icon color so they don't show up as white
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontFamily: _appFont,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.black54),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  static AppBarTheme appBarThemeDark() {
    return const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: _appFont,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }

  static ElevatedButtonThemeData customButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        textStyle: const TextStyle(fontSize: 16),
        padding: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }

  static ToggleButtonsThemeData customToggleButtonsTheme() {
    return const ToggleButtonsThemeData(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    );
  }
}
