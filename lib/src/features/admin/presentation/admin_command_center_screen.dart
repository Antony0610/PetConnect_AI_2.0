import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/widgets/glass_container.dart';

class AdminCommandCenterScreen extends StatefulWidget {
  const AdminCommandCenterScreen({super.key});

  @override
  State<AdminCommandCenterScreen> createState() => _AdminCommandCenterScreenState();
}

class _AdminCommandCenterScreenState extends State<AdminCommandCenterScreen> {
  bool _isLoading = false;

  void _showRbacDirectoryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Padding(
              padding: AppSpacing.paddingLg,
              child: ListView(
                controller: scrollController,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  AppSpacing.gapLg,
                  Text('RBAC User Directory & Security Controls', style: AppTypography.titleLarge(context).copyWith(color: Colors.white)),
                  const SizedBox(height: 4),
                  const Text('Manage platform permissions across 4 system roles', style: TextStyle(color: Colors.white70)),
                  AppSpacing.gapLg,
                  _buildRbacUserTile('Alex Morgan', 'alex@petconnect.ai', 'Pet Owner', AppColors.primaryTeal),
                  _buildRbacUserTile('Dr. Sarah Jenkins', 'sarah.vet@metro.clinic', 'Veterinarian', AppColors.secondaryCyan),
                  _buildRbacUserTile('Volunteer Worker #V-402', 'rescue@shelter.org', 'Volunteer', AppColors.tertiaryCoral),
                  _buildRbacUserTile('System Superuser', 'admin@petconnect.ai', 'Administrator', AppColors.successGreen),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRbacUserTile(String name, String email, String role, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: GlassContainer(
        padding: AppSpacing.paddingMd,
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(Icons.person, color: color),
            ),
            AppSpacing.gapMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(email, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            Chip(
              backgroundColor: color.withOpacity(0.2),
              label: Text(role, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Command Center'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Platform Metrics',
            onPressed: () async {
              setState(() => _isLoading = true);
              await Future.delayed(const Duration(milliseconds: 500));
              if (mounted) setState(() => _isLoading = false);
            },
          ),
          IconButton(
            icon: const Icon(Icons.switch_account),
            tooltip: 'Switch Portal',
            onPressed: () => context.go(AppRoutes.roleSelection),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
          : RefreshIndicator(
              onRefresh: () async {
                setState(() => _isLoading = true);
                await Future.delayed(const Duration(milliseconds: 500));
                if (mounted) setState(() => _isLoading = false);
              },
              child: SingleChildScrollView(
                padding: AppSpacing.paddingLg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // System Health Probes Status Bar
                    GlassContainer(
                      padding: AppSpacing.paddingMd,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildProbeIndicator('Liveness', '200 OK', AppColors.successGreen),
                          _buildProbeIndicator('Readiness', '200 OK', AppColors.successGreen),
                          _buildProbeIndicator('Startup', '200 OK', AppColors.successGreen),
                        ],
                      ),
                    ),
                    AppSpacing.gapLg,

                    Text('Platform Telemetry', style: AppTypography.headlineMedium(context)),
                    AppSpacing.gapMd,
                    Row(
                      children: [
                        Expanded(child: _buildMetricCard(context, 'Active Users', '142,850', Icons.people, AppColors.primaryTeal)),
                        AppSpacing.gapMd,
                        Expanded(child: _buildMetricCard(context, 'Collars Online', '98,420', Icons.bluetooth_connected, AppColors.secondaryCyan)),
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

                    Text('Enterprise Command Modules', style: AppTypography.headlineMedium(context)),
                    AppSpacing.gapMd,
                    GlassContainer(
                      child: ListTile(
                        leading: const Icon(Icons.admin_panel_settings, color: AppColors.primaryTeal),
                        title: const Text('User Management & RBAC Directory'),
                        subtitle: const Text('Manage 4 roles: Owners, Vets, Rescuers, Admins'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => _showRbacDirectoryModal(context),
                      ),
                    ),
                    AppSpacing.gapSm,
                    GlassContainer(
                      child: ListTile(
                        leading: const Icon(Icons.security, color: AppColors.secondaryCyan),
                        title: const Text('Security Audit & Access Logs'),
                        subtitle: const Text('Encryption keys, token refresh logs, SimpleJWT'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('SimpleJWT RBAC Tokens: All 13 Django domain apps verified')),
                          );
                        },
                      ),
                    ),
                    AppSpacing.gapSm,
                    GlassContainer(
                      child: ListTile(
                        leading: const Icon(Icons.memory, color: AppColors.tertiaryCoral),
                        title: const Text('AI Model & Token Performance'),
                        subtitle: const Text('Latency, Gemini 1.5 RAG vision accuracy'),
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
            ),
    );
  }

  Widget _buildProbeIndicator(String label, String status, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text('$label: ', style: const TextStyle(fontSize: 12, color: Colors.white70)),
        Text(status, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          AppSpacing.gapSm,
          Text(value, style: AppTypography.headlineLarge(context).copyWith(color: color)),
          Text(title, style: AppTypography.labelLarge(context)),
        ],
      ),
    );
  }
}
