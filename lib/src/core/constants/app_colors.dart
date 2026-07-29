import 'package:flutter/material.dart';

/// Design tokens for PetConnect AI Ecosystem
/// Handcrafted warm, compassionate palette: Deep Forest Green, Warm Teal, Golden Amber & Soft Coral.
abstract class AppColors {
  // Brand Primaries (Deep Forest Green & Warm Teal)
  static const Color primaryTeal = Color(0xFF0F4C3A);
  static const Color primaryContainer = Color(0xFF147B6A);
  static const Color primaryFixed = Color(0xFF89F5E7);
  static const Color primaryFixedDim = Color(0xFF6BD8CB);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFF4FFFC);

  // Brand Secondaries (Warm Teal & Golden Amber Accent)
  static const Color secondaryCyan = Color(0xFF147B6A);
  static const Color secondaryContainer = Color(0xFFE6A100);
  static const Color secondaryFixed = Color(0xFFFFF3CD);
  static const Color secondaryFixedDim = Color(0xFFE6A100);
  static const Color onSecondary = Color(0xFFFFFFFF);

  // Brand Tertiaries (Soft Coral Accent)
  static const Color tertiaryCoral = Color(0xFFE76F51);
  static const Color tertiaryContainer = Color(0xFFB05E3D);
  static const Color tertiaryFixed = Color(0xFFFFDBCE);
  static const Color tertiaryFixedDim = Color(0xFFFFB59A);
  static const Color onTertiary = Color(0xFFFFFFFF);

  // Light Neutrals (Warm Off-White & Soft Ivory)
  static const Color lightBackground = Color(0xFFFAFAF7);
  static const Color lightSurface = Color(0xFFF4F4EE);
  static const Color lightSurfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color lightSurfaceContainerLow = Color(0xFFEFF4FE);
  static const Color lightSurfaceContainer = Color(0xFFE5EEFE);
  static const Color lightSurfaceContainerHigh = Color(0xFFDCE9FE);
  static const Color lightSurfaceContainerHighest = Color(0xFFD3E4FE);
  static const Color lightOnSurface = Color(0xFF1C2421);
  static const Color lightOnSurfaceVariant = Color(0xFF3D4947);
  static const Color lightOutline = Color(0xFF6D7A77);
  static const Color lightOutlineVariant = Color(0xFFBCC9C6);

  // Dark Neutrals (Rich Charcoal & Deep Forest Charcoal)
  static const Color darkBackground = Color(0xFF121917);
  static const Color darkSurface = Color(0xFF1A2321);
  static const Color darkSurfaceContainerLowest = Color(0xFF0F1513);
  static const Color darkSurfaceContainerLow = Color(0xFF18221F);
  static const Color darkSurfaceContainer = Color(0xFF202C28);
  static const Color darkSurfaceContainerHigh = Color(0xFF283732);
  static const Color darkSurfaceContainerHighest = Color(0xFF31433D);
  static const Color darkOnSurface = Color(0xFFEAF1FF);
  static const Color darkOnSurfaceVariant = Color(0xFF94A3B8);
  static const Color darkOutline = Color(0xFF475569);
  static const Color darkOutlineVariant = Color(0xFF334155);

  // Semantics
  static const Color successGreen = Color(0xFF2A9D8F);
  static const Color warningOrange = Color(0xFFE6A100);
  static const Color errorRed = Color(0xFFE76F51);
  static const Color onError = Color(0xFFFFFFFF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryTeal, secondaryCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient aiGlowGradient = LinearGradient(
    colors: [Color(0xFF0F4C3A), Color(0xFF147B6A), Color(0xFFE6A100)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
