import 'package:flutter/material.dart';

/// Design tokens for PetConnect AI Ecosystem
/// Inspired by Apple Health clarity, Tesla UI precision, and Nothing OS glassmorphic & dot-matrix accents.
abstract class AppColors {
  // Brand Primaries
  static const Color primaryTeal = Color(0xFF00685F);
  static const Color primaryContainer = Color(0xFF008378);
  static const Color primaryFixed = Color(0xFF89F5E7);
  static const Color primaryFixedDim = Color(0xFF6BD8CB);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFF4FFFC);

  // Brand Secondaries (Cyan Accent)
  static const Color secondaryCyan = Color(0xFF00687A);
  static const Color secondaryContainer = Color(0xFF57DFFE);
  static const Color secondaryFixed = Color(0xFFACEDFF);
  static const Color secondaryFixedDim = Color(0xFF4CD7F6);
  static const Color onSecondary = Color(0xFFFFFFFF);

  // Brand Tertiaries (Coral Accent)
  static const Color tertiaryCoral = Color(0xFF924628);
  static const Color tertiaryContainer = Color(0xFFB05E3D);
  static const Color tertiaryFixed = Color(0xFFFFDBCE);
  static const Color tertiaryFixedDim = Color(0xFFFFB59A);
  static const Color onTertiary = Color(0xFFFFFFFF);

  // Light Neutrals
  static const Color lightBackground = Color(0xFFF8F9FF);
  static const Color lightSurface = Color(0xFFF8F9FF);
  static const Color lightSurfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color lightSurfaceContainerLow = Color(0xFFEFF4FF);
  static const Color lightSurfaceContainer = Color(0xFFE5EEFF);
  static const Color lightSurfaceContainerHigh = Color(0xFFDCE9FF);
  static const Color lightSurfaceContainerHighest = Color(0xFFD3E4FE);
  static const Color lightOnSurface = Color(0xFF0B1C30);
  static const Color lightOnSurfaceVariant = Color(0xFF3D4947);
  static const Color lightOutline = Color(0xFF6D7A77);
  static const Color lightOutlineVariant = Color(0xFFBCC9C6);

  // Dark Neutrals (OLED Navy/Black)
  static const Color darkBackground = Color(0xFF050811);
  static const Color darkSurface = Color(0xFF0B1C30);
  static const Color darkSurfaceContainerLowest = Color(0xFF081220);
  static const Color darkSurfaceContainerLow = Color(0xFF0E223B);
  static const Color darkSurfaceContainer = Color(0xFF152D4A);
  static const Color darkSurfaceContainerHigh = Color(0xFF1E3B5F);
  static const Color darkSurfaceContainerHighest = Color(0xFF264773);
  static const Color darkOnSurface = Color(0xFFEAF1FF);
  static const Color darkOnSurfaceVariant = Color(0xFF94A3B8);
  static const Color darkOutline = Color(0xFF475569);
  static const Color darkOutlineVariant = Color(0xFF334155);

  // Semantics
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryTeal, secondaryCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient aiGlowGradient = LinearGradient(
    colors: [Color(0xFF008378), Color(0xFF57DFFE), Color(0xFFB05E3D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
