import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/widgets/glass_container.dart';

class AdminCommandCenterScreen extends StatelessWidget {
  const AdminCommandCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Command Center'),
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
            Text('Platform Telemetry', style: AppTypography.headlineMedium(context)),
            AppSpacing.gapMd,
            Row(
              children: [
                Expanded(child: _buildMetricCard(context, 'Active Users', '142,850', Icons.people, AppColors.primaryTeal)),
                AppSpacing.gapMd,
                Expanded(child: _buildMetricCard(context, 'Smart Collars Online', '98,420', Icons.bluetooth_connected, AppColors.secondaryCyan)),
              ],
            ),
            AppSpacing.gapMd,
            Row(
              children: [
                Expanded(child: _buildMetricCard(context, 'AI Scans (24h)', '34,120', Icons.auto_awesome, AppColors.tertiaryCoral)),
                AppSpacing.gapMd,
                Expanded(child: _buildMetricCard(context, 'System Uptime', '99.98%', Icons.verified_user, AppColors.successGreen)),
              ],
            ),
            AppSpacing.gapLg,
            Text('Enterprise Modules', style: AppTypography.headlineMedium(context)),
            AppSpacing.gapMd,
            GlassContainer(
              child: ListTile(
                leading: const Icon(Icons.admin_panel_settings, color: AppColors.primaryTeal),
                title: const Text('User Management & RBAC Directory'),
                subtitle: const Text('Manage 4 roles: Owners, Vets, Rescuers, Admins'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ),
            AppSpacing.gapSm,
            GlassContainer(
              child: ListTile(
                leading: const Icon(Icons.security, color: AppColors.secondaryCyan),
                title: const Text('Security Audit & Access Logs'),
                subtitle: const Text('Encryption keys, token refresh logs, certificate pinning'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ),
            AppSpacing.gapSm,
            GlassContainer(
              child: ListTile(
                leading: const Icon(Icons.memory, color: AppColors.tertiaryCoral),
                title: const Text('AI Model & Token Performance'),
                subtitle: const Text('Latency, vision accuracy, confidence distributions'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ),
            AppSpacing.gapSm,
            GlassContainer(
              child: ListTile(
                leading: const Icon(Icons.system_update_alt, color: AppColors.primaryTeal),
                title: const Text('Smart Collar Fleet OTA Management'),
                subtitle: const Text('Push firmware updates to active collar clusters'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          AppSpacing.gapSm,
          Text(value, style: AppTypography.monoData(context, fontSize: 24, color: color)),
          Text(title, style: AppTypography.labelLarge(context)),
        ],
      ),
    );
  }
}
