import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable Glassmorphism Container Component for PetConnect AI Ecosystem
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = EdgeInsets.zero,
    this.borderRadius = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final glassTheme = Theme.of(context).extension<GlassmorphismThemeExtension>() ??
        const GlassmorphismThemeExtension(
          blurAmount: 20.0,
          fillOverlayColor: Color(0x99FFFFFF),
          borderStrokeColor: Color(0x1F00685F),
        );

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: glassTheme.blurAmount,
            sigmaY: glassTheme.blurAmount,
          ),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: glassTheme.fillOverlayColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: glassTheme.borderStrokeColor,
                width: 1.0,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
