import 'package:flutter/material.dart';

/// Dark / Aggressive / Energetic / Powerful RPG palette. No pastels.
class AppColors {
  static const background = Color(0xFF080808);
  static const card = Color(0xFF151515);
  static const cardBorder = Color(0xFF2A2A2A);
  static const red = Color(0xFFFF1744);
  static const orange = Color(0xFFFF6D00);
  static const magenta = Color(0xFFD500F9);
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFFB0B0B0);

  static const xpGradient = LinearGradient(
    colors: [red, orange, magenta],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.red,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.red,
        secondary: AppColors.magenta,
        surface: AppColors.card,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.card,
        selectedItemColor: AppColors.red,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: AppColors.textPrimary),
      ),
    );
  }
}
