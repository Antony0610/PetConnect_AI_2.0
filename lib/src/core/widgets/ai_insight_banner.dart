import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import 'glass_container.dart';

/// Reusable AI Diagnostic & Symptom Analysis Banner
class AIInsightBanner extends StatelessWidget {
  final String title;
  final String description;
  final String confidenceScore;
  final VoidCallback? onTapAction;

  const AIInsightBanner({
    super.key,
    required this.title,
    required this.description,
    required this.confidenceScore,
    this.onTapAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        gradient: AppColors.aiGlowGradient,
        padding: const EdgeInsets.all(1.5), // Subtle gradient border
      ),
      child: GlassContainer(
        borderRadius: AppSpacing.radiusLg - 1.5,
        child: Column(
          crossAxisAlignment: CrossAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.secondaryCyan, size: 20),
                AppSpacing.gapSm,
                Text(
                  title,
                  style: AppTypography.titleLarge(context).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTeal.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  ),
                  child: Text(
                    'AI Match: $confidenceScore',
                    style: AppTypography.labelLarge(context).copyWith(
                      color: AppColors.secondaryCyan,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.gapSm,
            Text(
              description,
              style: AppTypography.bodyMedium(context),
            ),
            if (onTapAction != null) ...[
              AppSpacing.gapSm,
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onTapAction,
                  icon: const Icon(Icons.arrow_forward_ios, size: 14),
                  label: const Text('View Full Diagnosis'),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
