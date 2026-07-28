import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import 'glass_container.dart';

/// Reusable Role Selection Card for Onboarding & Portal Switching
class RoleSelectorCard extends StatelessWidget {
  final String roleKey;
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleSelectorCard({
    super.key,
    required this.roleKey,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: isSelected ? AppColors.primaryTeal : Colors.transparent,
            width: 2.0,
          ),
        ),
        child: GlassContainer(
          padding: AppSpacing.paddingLg,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (isSelected ? AppColors.primaryTeal : AppColors.secondaryCyan).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isSelected ? AppColors.primaryTeal : AppColors.secondaryCyan,
                  size: 28,
                ),
              ),
              AppSpacing.gapMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleLarge(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? AppColors.primaryTeal : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppTypography.bodyMedium(context),
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected ? AppColors.primaryTeal : AppColors.lightOutlineVariant,
              )
            ],
          ),
        ),
      ),
    );
  }
}
