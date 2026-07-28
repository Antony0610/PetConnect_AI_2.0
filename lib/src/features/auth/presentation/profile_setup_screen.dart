import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/routing/app_router.dart';

class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Setup')),
      body: Padding(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Complete Your Profile', style: AppTypography.headlineLarge(context)),
            AppSpacing.gapXs,
            Text('Set up permissions and emergency contact information.', style: AppTypography.bodyMedium(context)),
            AppSpacing.gapLg,
            const TextField(
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            AppSpacing.gapMd,
            const TextField(
              decoration: InputDecoration(
                labelText: 'Emergency Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            AppSpacing.gapXl,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => context.go(AppRoutes.petOwnerDashboard),
                child: const Text('Complete Setup'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
