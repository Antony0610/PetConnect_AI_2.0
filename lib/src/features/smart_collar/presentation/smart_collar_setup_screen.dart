import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/widgets/glass_container.dart';

class SmartCollarSetupScreen extends StatefulWidget {
  const SmartCollarSetupScreen({super.key});

  @override
  State<SmartCollarSetupScreen> createState() => _SmartCollarSetupScreenState();
}

class _SmartCollarSetupScreenState extends State<SmartCollarSetupScreen> {
  bool _isScanning = false;
  bool _isPaired = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Collar Management')),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassContainer(
              padding: AppSpacing.paddingLg,
              child: Column(
                children: [
                  const Icon(Icons.bluetooth_connected, size: 48, color: AppColors.primaryTeal),
                  AppSpacing.gapMd,
                  Text('PetConnect Smart Collar v2', style: AppTypography.headlineMedium(context)),
                  Text('Device ID: SC-9821-BLE • MAC: 71:A2:88:CF', style: AppTypography.monoData(context)),
                  AppSpacing.gapMd,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoItem('Battery', '94%', Icons.battery_full, AppColors.successGreen),
                      _buildInfoItem('GPS Signal', 'Strong (12 SAT)', Icons.gps_fixed, AppColors.primaryTeal),
                      _buildInfoItem('Firmware', 'v2.4.1 (Latest)', Icons.system_update, AppColors.secondaryCyan),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.gapLg,
            Text('Geofence Safe Zones', style: AppTypography.headlineMedium(context)),
            AppSpacing.gapMd,
            GlassContainer(
              child: ListTile(
                leading: const Icon(Icons.home_work, color: AppColors.primaryTeal),
                title: const Text('Home Perimeter Safe Zone'),
                subtitle: const Text('Radius: 150m • Alerts: Push & SMS'),
                trailing: Switch(value: true, onChanged: (v) {}),
              ),
            ),
            AppSpacing.gapLg,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => context.go(AppRoutes.liveTracking),
                icon: const Icon(Icons.map),
                label: const Text('Open Live GPS Tracking Map'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
