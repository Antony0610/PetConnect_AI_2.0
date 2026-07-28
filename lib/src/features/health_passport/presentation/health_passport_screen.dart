import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/status_chip.dart';

class HealthPassportScreen extends StatelessWidget {
  const HealthPassportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Health Passport'),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassContainer(
              padding: AppSpacing.paddingLg,
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primaryTeal,
                    child: Icon(Icons.pets, size: 36, color: Colors.white),
                  ),
                  AppSpacing.gapMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Luna', style: AppTypography.headlineMedium(context)),
                        Text('Canine • Golden Retriever • 3 yrs 2 mos', style: AppTypography.bodyMedium(context)),
                        Text('Microchip ID: 985141002938102', style: AppTypography.labelLarge(context)),
                      ],
                    ),
                  ),
                  const StatusChip(label: 'Verified EHR', type: StatusType.success),
                ],
              ),
            ),
            AppSpacing.gapLg,
            Text('Vaccination History', style: AppTypography.headlineMedium(context)),
            AppSpacing.gapMd,
            _buildRecordItem(
              context,
              title: 'Rabies 3-Year Vaccine',
              date: 'Administered: Jan 15, 2025 • Expires: Jan 15, 2028',
              vet: 'Dr. Sarah Jenkins, DVM',
              isVerified: true,
            ),
            _buildRecordItem(
              context,
              title: 'DHPP Core Booster',
              date: 'Administered: Nov 10, 2024 • Expires: Nov 10, 2025',
              vet: 'Dr. Sarah Jenkins, DVM',
              isVerified: true,
            ),
            _buildRecordItem(
              context,
              title: 'Bordetella Oral Vaccine',
              date: 'Administered: Jun 02, 2024 • Expires: Jun 02, 2025',
              vet: 'Metro Pet Care Clinic',
              isVerified: true,
            ),
            AppSpacing.gapLg,
            Text('Medical & Surgery Ledger', style: AppTypography.headlineMedium(context)),
            AppSpacing.gapMd,
            _buildRecordItem(
              context,
              title: 'Routine Dental Scaling & Polish',
              date: 'Performed: Aug 14, 2024',
              vet: 'Metro Pet Care Clinic',
              isVerified: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordItem(
    BuildContext context, {
    required String title,
    required String date,
    required String vet,
    required bool isVerified,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: GlassContainer(
        padding: AppSpacing.paddingMd,
        child: Row(
          children: [
            const Icon(Icons.verified, color: AppColors.primaryTeal, size: 24),
            AppSpacing.gapMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.titleLarge(context)),
                  const SizedBox(height: 2),
                  Text(date, style: AppTypography.bodyMedium(context)),
                  Text(vet, style: AppTypography.labelLarge(context)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.lightOutlineVariant),
          ],
        ),
      ),
    );
  }
}
