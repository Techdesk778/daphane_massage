import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      // Base background is now the deep, professional Navy
      scaffoldBackgroundColor: AppColors.navy,
      fontFamily: GoogleFonts.lato().fontFamily,

      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: AppColors.sharpPink,
        primary: AppColors.sharpPink,      // Main action color
        secondary: AppColors.sharpPink,    // Accent color
        surface: Colors.white,             // Cards remain clean white
        onSurface: AppColors.navy,         // Text on cards uses Navy for readability
      ),

      textTheme: TextTheme(
        bodyMedium: const TextStyle(color: Colors.white),
        headlineMedium: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        bodySmall: TextStyle(color: AppColors.textLight),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.navy,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.sharpPink, // Button is now the sharp accent
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),

      cardTheme: const CardTheme(
        color: Colors.white,
      ),
    );
  }
}