import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import 'glass_container.dart';

/// Reusable Pet Vitals Card Widget displaying real-time telemetry
class PetVitalsCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color accentColor;
  final String statusText;
  final bool isAlert;

  const PetVitalsCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    this.accentColor = AppColors.primaryTeal,
    required this.statusText,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: AppSpacing.paddingMd,
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Icon(icon, color: accentColor, size: 20),
                  ),
                  AppSpacing.gapSm,
                  Text(title, style: AppTypography.titleLarge(context)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (isAlert ? AppColors.errorRed : AppColors.successGreen).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isAlert ? AppColors.errorRed : AppColors.successGreen,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapMd,
          Row(
            crossAxisAlignment: CrossAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: AppTypography.monoData(
                  context,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isAlert ? AppColors.errorRed : accentColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: AppTypography.bodyMedium(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
