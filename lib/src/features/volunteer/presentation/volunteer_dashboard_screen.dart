import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/widgets/glass_container.dart';

class VolunteerDashboardScreen extends StatefulWidget {
  const VolunteerDashboardScreen({super.key});

  @override
  State<VolunteerDashboardScreen> createState() => _VolunteerDashboardScreenState();
}

class _VolunteerDashboardScreenState extends State<VolunteerDashboardScreen> {
  bool _isOnDuty = true;

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
            // Volunteer Profile & Duty Toggle Card
            GlassContainer(
              padding: AppSpacing.paddingLg,
              child: Column(
                children: [
                  Row(
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
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.gapLg,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _isOnDuty ? Icons.check_circle : Icons.do_not_disturb_on,
                            color: _isOnDuty ? AppColors.successGreen : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _isOnDuty ? 'ON DUTY • Dispatch Ready' : 'OFF DUTY • Standby',
                            style: TextStyle(
                              color: _isOnDuty ? AppColors.successGreen : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: _isOnDuty,
                        activeColor: AppColors.successGreen,
                        onChanged: (v) {
                          setState(() => _isOnDuty = v);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(v ? 'Status set to ON DUTY' : 'Status set to OFF DUTY')),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.gapLg,

            // Live Metrics Counter Row
            Row(
              children: [
                Expanded(child: _buildStatCard(context, '3 Active', 'Incidents Nearby', Icons.warning_amber, AppColors.errorRed)),
                AppSpacing.gapMd,
                Expanded(child: _buildStatCard(context, '42', 'Rescues Completed', Icons.verified, AppColors.primaryTeal)),
                AppSpacing.gapMd,
                Expanded(child: _buildStatCard(context, '15m', 'Avg Response Time', Icons.speed, AppColors.secondaryCyan)),
              ],
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

  Widget _buildStatCard(BuildContext context, String value, String label, IconData icon, Color color) {
    return GlassContainer(
      padding: AppSpacing.paddingSm,
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.white70), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildAlertCard(
    BuildContext context, {
    required String title,
    required String location,
    required String time,
    required String status,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: GlassContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.notifications_active, color: AppColors.tertiaryCoral),
                AppSpacing.gapSm,
                Text(title, style: AppTypography.titleMedium(context)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.tertiaryCoral.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                  child: Text(status, style: const TextStyle(color: AppColors.tertiaryCoral, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            AppSpacing.gapSm,
            Text(location, style: AppTypography.bodySmall(context)),
            Text(time, style: AppTypography.labelSmall(context)),
          ],
        ),
      ),
    );
  }
}
