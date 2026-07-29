import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/repositories/collar_repository.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/widgets/glass_container.dart';

class SmartCollarSetupScreen extends StatefulWidget {
  const SmartCollarSetupScreen({super.key});

  @override
  State<SmartCollarSetupScreen> createState() => _SmartCollarSetupScreenState();
}

class _SmartCollarSetupScreenState extends State<SmartCollarSetupScreen> with SingleTickerProviderStateMixin {
  final CollarRepository _collarRepository = CollarRepository();
  late AnimationController _bleScanController;
  late Animation<double> _bleScanAnimation;

  bool _isScanning = false;
  bool _isPaired = true;
  bool _isUpdatingOta = false;
  double _otaProgress = 0.0;
  Map<String, dynamic> _telemetry = {};

  @override
  void initState() {
    super.initState();
    _bleScanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _bleScanAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _bleScanController, curve: Curves.easeInOut),
    );

    _loadTelemetry();
  }

  @override
  void dispose() {
    _bleScanController.dispose();
    super.dispose();
  }

  Future<void> _loadTelemetry() async {
    final data = await _collarRepository.getCollarTelemetry('collar_001');
    if (mounted) {
      setState(() => _telemetry = data);
    }
  }

  void _triggerBlePairingWizard() {
    setState(() => _isScanning = true);
    _bleScanController.repeat(reverse: true);

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: AppSpacing.paddingLg,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                  ),
                  AppSpacing.gapLg,
                  AnimatedBuilder(
                    animation: _bleScanAnimation,
                    builder: (context, child) {
                      return Container(
                        width: 80 * _bleScanAnimation.value,
                        height: 80 * _bleScanAnimation.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryTeal.withOpacity(0.2),
                          border: Border.all(color: AppColors.primaryTeal),
                        ),
                        child: Icon(_isScanning ? Icons.bluetooth_searching : Icons.bluetooth_connected, color: AppColors.secondaryCyan, size: 36),
                      );
                    },
                  ),
                  AppSpacing.gapLg,
                  Text('Scanning for Nearby Collar Hardware...', style: AppTypography.titleLarge(context).copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  const Text('Hold device within 2 meters of smartphone', style: TextStyle(color: Colors.white70)),
                  AppSpacing.gapLg,
                  ListTile(
                    tileColor: Colors.white10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    leading: const Icon(Icons.bluetooth_connected, color: AppColors.primaryTeal),
                    title: const Text('PetConnect Collar v2 (SC-9821)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Signal: -42 dBm • Battery: 94%', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal),
                      onPressed: () async {
                        await _collarRepository.pairDevice('collar_001', 'SECRET_8821');
                        if (!context.mounted) return;
                        _bleScanController.stop();
                        setState(() {
                          _isPaired = true;
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Collar paired successfully via BLE Security Key!')),
                        );
                      },
                      child: const Text('Pair Now', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      _bleScanController.stop();
      setState(() => _isScanning = false);
    });
  }

  void _triggerOtaUpdate() async {
    setState(() {
      _isUpdatingOta = true;
      _otaProgress = 0.1;
    });

    for (int i = 2; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 250));
      if (mounted) {
        setState(() => _otaProgress = i / 10.0);
      }
    }

    if (mounted) {
      setState(() => _isUpdatingOta = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTA Firmware updated cleanly to v2.4.2!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final battery = _telemetry['battery_level'] ?? 94;
    final geofenceStatus = _telemetry['geofence_status'] ?? 'SAFE';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Collar Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bluetooth_searching),
            tooltip: 'Pair Device Wizard',
            onPressed: _triggerBlePairingWizard,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Master Collar Status Card
            GlassContainer(
              padding: AppSpacing.paddingLg,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.bluetooth_connected, size: 40, color: AppColors.primaryTeal),
                      Chip(
                        backgroundColor: AppColors.successGreen.withOpacity(0.2),
                        label: Text('Paiired & Connected ($geofenceStatus)', style: const TextStyle(color: AppColors.successGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  AppSpacing.gapMd,
                  Text('PetConnect Smart Collar v2', style: AppTypography.headlineMedium(context)),
                  Text('Device ID: SC-9821-BLE • MAC: 71:A2:88:CF', style: AppTypography.monoData(context)),
                  AppSpacing.gapLg,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoItem('Battery', '$battery%', Icons.battery_full, AppColors.successGreen),
                      _buildInfoItem('Status', _isPaired ? 'Paired (BLE)' : 'Scanning', Icons.bluetooth_connected, AppColors.primaryTeal),
                      _buildInfoItem('Firmware', 'v2.4.1 (Latest)', Icons.system_update, AppColors.secondaryCyan),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.gapLg,

            // OTA Firmware Update Card
            GlassContainer(
              padding: AppSpacing.paddingMd,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.system_update, color: AppColors.secondaryCyan),
                      AppSpacing.gapSm,
                      Text('OTA Firmware Manager', style: AppTypography.titleMedium(context)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text('Latest v2.4.2 patch is available for download.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  if (_isUpdatingOta) ...[
                    const SizedBox(height: 12),
                    LinearProgressIndicator(value: _otaProgress, backgroundColor: Colors.white12, color: AppColors.secondaryCyan),
                    const SizedBox(height: 4),
                    Text('Flashing Firmware: ${(_otaProgress * 100).toInt()}%', style: const TextStyle(fontSize: 10, color: AppColors.secondaryCyan)),
                  ] else ...[
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondaryCyan),
                      onPressed: _triggerOtaUpdate,
                      icon: const Icon(Icons.download, size: 18, color: Colors.white),
                      label: const Text('Update Firmware OTA', style: TextStyle(color: Colors.white)),
                    ),
                  ],
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
                label: const Text('Open Live GPS Tracking Radar Map'),
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
