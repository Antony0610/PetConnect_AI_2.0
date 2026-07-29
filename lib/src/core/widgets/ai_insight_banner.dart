import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import 'glass_container.dart';

/// Reusable AI Diagnostic & Symptom Analysis Banner with warm handcrafted styling
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
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: AppColors.aiGlowGradient,
      ),
      child: GlassContainer(
        borderRadius: 18.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome, color: AppColors.secondaryContainer, size: 18),
                ),
                AppSpacing.gapSm,
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.titleLarge(context).copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.secondaryContainer.withOpacity(0.4)),
                  ),
                  child: Text(
                    'RAG Match $confidenceScore',
                    style: const TextStyle(
                      color: AppColors.secondaryContainer,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.gapSm,
            Text(
              description,
              style: AppTypography.bodyMedium(context).copyWith(color: Colors.white70),
            ),
            if (onTapAction != null) ...[
              AppSpacing.gapSm,
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onTapAction,
                  icon: const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.secondaryCyan),
                  label: const Text('Consult AI Assistant', style: TextStyle(color: AppColors.secondaryCyan, fontWeight: FontWeight.bold)),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
