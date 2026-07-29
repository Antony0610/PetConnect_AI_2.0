import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// Glassmorphism Custom Theme Extension for PetConnect AI Ecosystem
class GlassmorphismThemeExtension extends ThemeExtension<GlassmorphismThemeExtension> {
  final double blurAmount;
  final Color fillOverlayColor;
  final Color borderStrokeColor;

  const GlassmorphismThemeExtension({
    required this.blurAmount,
    required this.fillOverlayColor,
    required this.borderStrokeColor,
  });

  @override
  GlassmorphismThemeExtension copyWith({
    double? blurAmount,
    Color? fillOverlayColor,
    Color? borderStrokeColor,
  }) {
    return GlassmorphismThemeExtension(
      blurAmount: blurAmount ?? this.blurAmount,
      fillOverlayColor: fillOverlayColor ?? this.fillOverlayColor,
      borderStrokeColor: borderStrokeColor ?? this.borderStrokeColor,
    );
  }

  @override
  GlassmorphismThemeExtension lerp(ThemeExtension<GlassmorphismThemeExtension>? other, double t) {
    if (other is! GlassmorphismThemeExtension) return this;
    return GlassmorphismThemeExtension(
      blurAmount: lerpDouble(blurAmount, other.blurAmount, t) ?? blurAmount,
      fillOverlayColor: Color.lerp(fillOverlayColor, other.fillOverlayColor, t) ?? fillOverlayColor,
      borderStrokeColor: Color.lerp(borderStrokeColor, other.borderStrokeColor, t) ?? borderStrokeColor,
    );
  }

  double? lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) return null;
    a ??= 0.0;
    b ??= 0.0;
    return a + (b - a) * t;
  }
}

/// Material Design 3 Theme Data for PetConnect AI
abstract class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primaryTeal,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondaryCyan,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: Color(0xFF006172),
        tertiary: AppColors.tertiaryCoral,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: Color(0xFFFFBFFF),
        error: AppColors.errorRed,
        onError: AppColors.onError,
        errorContainer: Color(0xFFFFDAD6),
        onErrorContainer: Color(0xFF93000A),
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightOnSurface,
        surfaceContainerLowest: AppColors.lightSurfaceContainerLowest,
        surfaceContainerLow: AppColors.lightSurfaceContainerLow,
        surfaceContainer: AppColors.lightSurfaceContainer,
        surfaceContainerHigh: AppColors.lightSurfaceContainerHigh,
        surfaceContainerHighest: AppColors.lightSurfaceContainerHighest,
        onSurfaceVariant: AppColors.lightOnSurfaceVariant,
        outline: AppColors.lightOutline,
        outlineVariant: AppColors.lightOutlineVariant,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: const BorderSide(color: AppColors.lightOutlineVariant, width: 1),
        ),
        color: AppColors.lightSurfaceContainerLowest,
      ),
      extensions: const [
        GlassmorphismThemeExtension(
          blurAmount: 20.0,
          fillOverlayColor: Color(0x99FFFFFF),
          borderStrokeColor: Color(0x1F00685F),
        ),
      ],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primaryFixedDim,
        onPrimary: Color(0xFF003732),
        primaryContainer: AppColors.primaryTeal,
        onPrimaryContainer: AppColors.primaryFixed,
        secondary: AppColors.secondaryFixedDim,
        onSecondary: Color(0xFF003641),
        secondaryContainer: AppColors.secondaryCyan,
        onSecondaryContainer: AppColors.secondaryFixed,
        tertiary: AppColors.tertiaryFixedDim,
        onTertiary: Color(0xFF561F09),
        tertiaryContainer: AppColors.tertiaryCoral,
        onTertiaryContainer: AppColors.tertiaryFixed,
        error: Color(0xFFFFB4AB),
        onError: Color(0xFF690005),
        errorContainer: AppColors.errorRed,
        onErrorContainer: Color(0xFFFFDAD6),
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkOnSurface,
        surfaceContainerLowest: AppColors.darkSurfaceContainerLowest,
        surfaceContainerLow: AppColors.darkSurfaceContainerLow,
        surfaceContainer: AppColors.darkSurfaceContainer,
        surfaceContainerHigh: AppColors.darkSurfaceContainerHigh,
        surfaceContainerHighest: AppColors.darkSurfaceContainerHighest,
        onSurfaceVariant: AppColors.darkOnSurfaceVariant,
        outline: AppColors.darkOutline,
        outlineVariant: AppColors.darkOutlineVariant,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: const BorderSide(color: AppColors.darkOutlineVariant, width: 1),
        ),
        color: AppColors.darkSurfaceContainerLowest,
      ),
      extensions: const [
        GlassmorphismThemeExtension(
          blurAmount: 20.0,
          fillOverlayColor: Color(0x801A2321),
          borderStrokeColor: Color(0x33147B6A),
        ),
      ],
    );
  }
}
