import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import 'glass_container.dart';

/// Reusable Pet Vitals Card Widget displaying real-time telemetry with organic pet-inspired styling
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
      borderRadius: 20.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: accentColor, size: 20),
                  ),
                  AppSpacing.gapSm,
                  Text(title, style: AppTypography.titleLarge(context).copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (isAlert ? AppColors.tertiaryCoral : AppColors.successGreen).withOpacity(0.18),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: (isAlert ? AppColors.tertiaryCoral : AppColors.successGreen).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isAlert ? AppColors.tertiaryCoral : AppColors.successGreen,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isAlert ? AppColors.tertiaryCoral : AppColors.successGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.gapMd,
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: AppTypography.monoData(
                  context,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: isAlert ? AppColors.tertiaryCoral : accentColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: AppTypography.bodyMedium(context).copyWith(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
