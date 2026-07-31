import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/glass_container.dart';

class SmartCollarScreen extends StatefulWidget {
  const SmartCollarScreen({super.key});

  @override
  State<SmartCollarScreen> createState() => _SmartCollarScreenState();
}

class _SmartCollarScreenState extends State<SmartCollarScreen> with SingleTickerProviderStateMixin {
  bool _isBluetoothConnected = true;
  final bool _isWifiConnected = true;
  final bool _isGpsLocked = true;
  bool _isLostMode = false;
  double _geofenceRadius = 150.0;
  final int _batteryPercent = 94;
  final int _signalRssi = -42;

  bool _isUpdatingOta = false;
  double _otaProgress = 0.0;

  final String _serialNumber = 'SC-9842-X7';
  final String _macAddress = '71:A2:88:CF:14:09';
  final String _firmwareVersion = 'v2.4.2-prod';
  final String _lastSyncTime = '2 mins ago';

  void _triggerSosAlert() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.errorRed),
            SizedBox(width: 8),
            Text('Broadcast SOS Alert?'),
          ],
        ),
        content: const Text('This will immediately alert nearby volunteers, veterinary clinics, and broadcast emergency GPS coordinates to your emergency contacts.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('EMERGENCY SOS ALERT BROADCASTED! Volunteers & Vets notified.')),
              );
            },
            child: const Text('CONFIRM SOS'),
          ),
        ],
      ),
    );
  }

  void _toggleLostMode(bool value) {
    setState(() => _isLostMode = value);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isLostMode ? 'LOST MODE ACTIVATED! High-frequency GPS pinging enabled.' : 'Lost Mode Deactivated.')),
    );
  }

  void _triggerOtaUpdate() async {
    setState(() {
      _isUpdatingOta = true;
      _otaProgress = 0.0;
    });

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) setState(() => _otaProgress = i / 10.0);
    }

    if (mounted) {
      setState(() => _isUpdatingOta = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTA Firmware updated to latest v2.5.0!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Collar Manager'),
        actions: [
          IconButton(
            icon: Icon(_isLostMode ? Icons.warning : Icons.warning_amber_outlined, color: _isLostMode ? AppColors.errorRed : null),
            tooltip: 'Lost Mode Toggle',
            onPressed: () => _toggleLostMode(!_isLostMode),
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: AppRoutes.smartCollarSetup),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isLostMode) ...[
              Container(
                padding: AppSpacing.paddingMd,
                decoration: BoxDecoration(
                  color: AppColors.errorRed,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.wifi_tethering, color: Colors.white, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('LOST PET MODE ACTIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('Live high-precision GPS telemetry is broadcasting to PetConnect Rescue Radar.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.gapLg,
            ],
            GlassContainer(
              padding: AppSpacing.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: AppColors.primaryTeal,
                            child: Icon(Icons.bolt, color: Colors.white),
                          ),
                          AppSpacing.gapSm,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('PetConnect Smart Collar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text('SN: $_serialNumber', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() => _isBluetoothConnected = !_isBluetoothConnected);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _isBluetoothConnected ? Colors.green.withOpacity(0.15) : Colors.red.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _isBluetoothConnected ? 'ONLINE' : 'DISCONNECTED',
                            style: TextStyle(
                              color: _isBluetoothConnected ? Colors.green.shade700 : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatusItem('Bluetooth', _isBluetoothConnected ? 'Connected' : 'Off', Icons.bluetooth, _isBluetoothConnected ? Colors.blue : Colors.grey),
                      _buildStatusItem('WiFi', _isWifiConnected ? 'Home-5G' : 'Off', Icons.wifi, _isWifiConnected ? Colors.green : Colors.grey),
                      _buildStatusItem('GPS Lock', _isGpsLocked ? 'Active' : 'Searching', Icons.gps_fixed, _isGpsLocked ? AppColors.primaryTeal : Colors.orange),
                      _buildStatusItem('Battery', '$_batteryPercent%', Icons.battery_charging_full, Colors.green),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.gapLg,
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.errorRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _triggerSosAlert,
                    icon: const Icon(Icons.sos, size: 24),
                    label: const Text('EMERGENCY SOS', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                AppSpacing.gapMd,
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _isLostMode ? AppColors.errorRed : AppColors.primaryTeal,
                      side: BorderSide(color: _isLostMode ? AppColors.errorRed : AppColors.primaryTeal, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => _toggleLostMode(!_isLostMode),
                    icon: Icon(_isLostMode ? Icons.check_circle : Icons.warning_amber),
                    label: Text(_isLostMode ? 'Turn Off Lost Mode' : 'Enable Lost Mode', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            AppSpacing.gapLg,
            Text('Geofence Safe Zone', style: AppTypography.headlineMedium(context)),
            AppSpacing.gapMd,
            GlassContainer(
              padding: AppSpacing.paddingMd,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Safe Radius Constraint', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${_geofenceRadius.toInt()} meters', style: const TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Slider(
                    value: _geofenceRadius,
                    min: 50,
                    max: 2000,
                    divisions: 39,
                    activeColor: AppColors.primaryTeal,
                    onChanged: (val) => setState(() => _geofenceRadius = val),
                  ),
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: (_geofenceRadius / 2000) * 160 + 40,
                          height: (_geofenceRadius / 2000) * 160 + 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryTeal.withOpacity(0.2),
                            border: Border.all(color: AppColors.primaryTeal, width: 2),
                          ),
                        ),
                        const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.location_on, color: AppColors.tertiaryCoral, size: 36),
                            Text('Luna (Home)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.gapMd,
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => context.go(AppRoutes.liveTracking),
                      icon: const Icon(Icons.map),
                      label: const Text('Open Full Screen Live GPS Radar'),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapLg,
            Text('Collar Activity History (Past 7 Days)', style: AppTypography.headlineMedium(context)),
            AppSpacing.gapMd,
            GlassContainer(
              padding: AppSpacing.paddingMd,
              child: SizedBox(
                height: 160,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 7200),
                          FlSpot(1, 8400),
                          FlSpot(2, 6900),
                          FlSpot(3, 9100),
                          FlSpot(4, 8420),
                          FlSpot(5, 7800),
                          FlSpot(6, 8900),
                        ],
                        isCurved: true,
                        color: AppColors.primaryTeal,
                        barWidth: 3,
                        dotData: const FlDotData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AppSpacing.gapLg,
            Text('Device Information & OTA Firmware', style: AppTypography.headlineMedium(context)),
            AppSpacing.gapMd,
            GlassContainer(
              padding: AppSpacing.paddingMd,
              child: Column(
                children: [
                  _buildDetailRow('MAC Address', _macAddress),
                  const Divider(),
                  _buildDetailRow('Firmware Version', _firmwareVersion),
                  const Divider(),
                  _buildDetailRow('Signal RSSI', '$_signalRssi dBm (Strong)'),
                  const Divider(),
                  _buildDetailRow('Last Telemetry Sync', _lastSyncTime),
                  AppSpacing.gapMd,
                  if (_isUpdatingOta) ...[
                    LinearProgressIndicator(value: _otaProgress, color: AppColors.primaryTeal),
                    AppSpacing.gapSm,
                    Text('Updating OTA Firmware: ${(_otaProgress * 100).toInt()}%', style: const TextStyle(fontSize: 12)),
                  ] else ...[
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _triggerOtaUpdate,
                        icon: const Icon(Icons.system_update),
                        label: const Text('Check for OTA Firmware Update'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            AppSpacing.gapLg,
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
