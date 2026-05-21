import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryRed,
        brightness: Brightness.dark,
        primary: AppColors.primaryRed,
        secondary: AppColors.primaryYellow,
        surface: AppColors.deepRed,
      ),
      scaffoldBackgroundColor: AppColors.darkRed,
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkRed,
        foregroundColor: AppColors.cream,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
