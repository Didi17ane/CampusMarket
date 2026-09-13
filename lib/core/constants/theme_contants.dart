import 'package:flutter/material.dart';

class AppColors {
  static const Color orangePrincipal = Color(0xFFFF6600);
  static const Color orangeFonce = Color(0xFFD64A00);
  static const Color noir = Color(0xFF121212);
  static const Color blanc = Color(0xFFFFFFFF);
  static const Color grisClair = Color(0xFFEEEEEE);
  static const Color grisTexte = Color(0xFF8E8E8E);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.orangePrincipal,
      scaffoldBackgroundColor: AppColors.grisClair, // Fond gris très clair d'après la charte
      fontFamily: 'Inter',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.noir,
        foregroundColor: AppColors.blanc,
        elevation: 0,
      ),
    );
  }
}
