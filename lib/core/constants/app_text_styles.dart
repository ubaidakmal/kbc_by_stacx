import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static TextStyle get headingLarge => GoogleFonts.poppins(
    color: AppColors.cream,
    fontSize: 34,
    fontWeight: FontWeight.w800,
    height: 1.08,
  );

  static TextStyle get headingMedium => GoogleFonts.poppins(
    color: AppColors.cream,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.15,
  );

  static TextStyle get body => GoogleFonts.poppins(
    color: AppColors.softYellow,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.45,
  );

  static TextStyle get bodySmall => GoogleFonts.poppins(
    color: AppColors.cream,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.35,
  );

  static TextStyle get label => GoogleFonts.poppins(
    color: AppColors.primaryYellow,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0,
  );

  static TextStyle get button => GoogleFonts.poppins(
    color: AppColors.darkRed,
    fontSize: 15,
    fontWeight: FontWeight.w800,
    height: 1.2,
  );
}
