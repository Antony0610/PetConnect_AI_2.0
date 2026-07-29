import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography tokens for PetConnect AI Ecosystem
/// Headlines: Plus Jakarta Sans
/// Body & Labels: Inter
/// Data & Numbers: Manrope
abstract class AppTypography {
  // Display Headings
  static TextStyle displayLarge(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.plusJakartaSans(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      height: 1.22,
      letterSpacing: -0.72,
      color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
    );
  }

  static TextStyle headlineLarge(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.plusJakartaSans(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      height: 1.25,
      letterSpacing: -0.28,
      color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
    );
  }

  static TextStyle headlineMedium(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.plusJakartaSans(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.33,
      color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
    );
  }

  static TextStyle titleLarge(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.plusJakartaSans(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      height: 1.33,
      color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
    );
  }

  static TextStyle titleMedium(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.plusJakartaSans(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.35,
      color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
    );
  }

  // Body
  static TextStyle bodyLarge(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.43,
      color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOnSurfaceVariant,
    );
  }

  static TextStyle bodySmall(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.33,
      color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOnSurfaceVariant,
    );
  }

  // Labels
  static TextStyle labelLarge(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.33,
      letterSpacing: 0.6,
      color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
    );
  }

  static TextStyle labelSmall(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      height: 1.25,
      letterSpacing: 0.4,
      color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOnSurfaceVariant,
    );
  }

  // Telemetry & Numeric Data
  static TextStyle monoData(BuildContext context, {double fontSize = 14, FontWeight fontWeight = FontWeight.w600, Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.manrope(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: 1.4,
      color: color ?? (isDark ? AppColors.secondaryFixedDim : AppColors.primaryTeal),
    );
  }
}
