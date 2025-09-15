import 'package:flutter/material.dart';
import 'app_colors.dart'; // استيراد ملف الألوان

class AppThemes {
  // تعريف الثيم الفاتح
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryLight,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryLight,
      titleTextStyle: TextStyle(color: AppColors.cardLight, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.cardLight,
      elevation: 2,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryLight,
      foregroundColor: AppColors.cardLight,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textLight),
      bodyMedium: TextStyle(color: AppColors.textLight),
      titleLarge: TextStyle(color: AppColors.textLight),
    ),
    iconTheme: const IconThemeData(color: AppColors.primaryLight),
    dialogBackgroundColor: AppColors.cardLight,
  );

  // تعريف الثيم الداكن
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryDark,
      titleTextStyle: TextStyle(color: AppColors.textDark, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.cardDark,
      elevation: 2,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryDark,
      foregroundColor: AppColors.textDark,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textDark),
      bodyMedium: TextStyle(color: AppColors.textDark),
      titleLarge: TextStyle(color: AppColors.textDark),
    ),
    iconTheme: const IconThemeData(color: AppColors.primaryDark),
    dialogBackgroundColor: AppColors.cardDark,
  );
}