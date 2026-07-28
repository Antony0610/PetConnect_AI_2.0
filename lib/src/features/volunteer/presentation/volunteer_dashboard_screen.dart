import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/widgets/glass_container.dart';

class VolunteerDashboardScreen extends StatelessWidget {
  const VolunteerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Mission Control'),
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
            GlassContainer(
              padding: AppSpacing.paddingLg,
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.tertiaryCoral,
                    child: Icon(Icons.volunteer_activism, size: 30, color: Colors.white),
                  ),
                  AppSpacing.gapMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rescue Worker #V-402', style: AppTypography.titleLarge(context)),
                        Text('Active Squad: Central Shelter Rescuers', style: AppTypography.bodyMedium(context)),
                        Text('Total Rescues Assisted: 42', style: AppTypography.labelLarge(context)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapLg,
            Text('Quick Rescue Dispatch', style: AppTypography.headlineMedium(context)),
            AppSpacing.gapMd,
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.errorRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => context.go(AppRoutes.rescueHub),
                    icon: const Icon(Icons.warning),
                    label: const Text('Rescue Missions'),
                  ),
                ),
                AppSpacing.gapMd,
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryCyan,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => context.go(AppRoutes.rescueMap),
                    icon: const Icon(Icons.map),
                    label: const Text('Live Dispatch Map'),
                  ),
                ),
              ],
            ),
            AppSpacing.gapLg,
            Text('Recent Stray & Lost Alerts', style: AppTypography.headlineMedium(context)),
            AppSpacing.gapMd,
            _buildAlertCard(
              context,
              title: 'Stray Husky Reported',
              location: '0.8 km away • Central Park East Gate',
              time: '12 mins ago',
              status: 'Urgent Dispatch',
            ),
            _buildAlertCard(
              context,
              title: 'Lost Tabby Cat (Microchipped)',
              location: '1.4 km away • 5th Avenue Transit',
              time: '45 mins ago',
              status: 'AI Noseprint Matched',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(BuildContext context, {required String title, required String location, required String time, required String status}) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: GlassContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: AppTypography.titleLarge(context)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.tertiaryCoral.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(status, style: const TextStyle(color: AppColors.tertiaryCoral, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(location, style: AppTypography.bodyMedium(context)),
            Text(time, style: AppTypography.labelLarge(context)),
          ],
        ),
      ),
    );
  }
}
