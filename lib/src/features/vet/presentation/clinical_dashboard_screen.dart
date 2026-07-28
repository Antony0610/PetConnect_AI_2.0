import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/status_chip.dart';

class ClinicalDashboardScreen extends StatelessWidget {
  const ClinicalDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Veterinarian Clinical Hub'),
            Text('Metro Pet Hospital • Dr. Sarah Jenkins', style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.switch_account),
            onPressed: () => context.go(AppRoutes.roleSelection),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(context, 'Appointments Today', '12', Icons.calendar_month, AppColors.primaryTeal),
                ),
                AppSpacing.gapMd,
                Expanded(
                  child: _buildMetricTile(context, 'Emergency Triage', '2', Icons.error_outline, AppColors.errorRed),
                ),
              ],
            ),
            AppSpacing.gapLg,
            Text('Patient Queue', style: AppTypography.headlineMedium(context)),
            AppSpacing.gapMd,
            _buildPatientTile(
              context,
              petName: 'Luna (Golden Retriever)',
              ownerName: 'Owner: Alex Morgan',
              reason: 'Routine Vitals & Dental Scaling Checkup',
              time: '10:30 AM',
              status: StatusType.success,
              statusText: 'Checked In',
            ),
            _buildPatientTile(
              context,
              petName: 'Max (German Shepherd)',
              ownerName: 'Owner: Rachel Green',
              reason: 'AI Skin Lesion Alert Scan Review',
              time: '11:15 AM',
              status: StatusType.warning,
              statusText: 'AI Flagged',
            ),
            _buildPatientTile(
              context,
              petName: 'Bella (Persian Cat)',
              ownerName: 'Owner: David Miller',
              reason: 'Teleconsultation Follow-up',
              time: '02:00 PM',
              status: StatusType.info,
              statusText: 'Teleconsult',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(BuildContext context, String label, String value, IconData icon, Color color) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          AppSpacing.gapSm,
          Text(value, style: AppTypography.headlineLarge(context).copyWith(color: color)),
          Text(label, style: AppTypography.labelLarge(context)),
        ],
      ),
    );
  }

  Widget _buildPatientTile(
    BuildContext context, {
    required String petName,
    required String ownerName,
    required String reason,
    required String time,
    required StatusType status,
    required String statusText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: GlassContainer(
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.primaryTeal,
              child: Icon(Icons.pets, color: Colors.white),
            ),
            AppSpacing.gapMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(petName, style: AppTypography.titleLarge(context)),
                  Text(ownerName, style: AppTypography.labelLarge(context)),
                  Text(reason, style: AppTypography.bodyMedium(context)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(time, style: AppTypography.monoData(context)),
                const SizedBox(height: 4),
                StatusChip(label: statusText, type: status),
              ],
            )
          ],
        ),
      ),
    );
  }
}
