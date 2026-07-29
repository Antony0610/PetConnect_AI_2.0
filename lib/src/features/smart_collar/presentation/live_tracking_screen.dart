import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/repositories/collar_repository.dart';
import '../../../core/widgets/glass_container.dart';

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  final CollarRepository _collarRepository = CollarRepository();
  Map<String, dynamic> _telemetry = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTelemetry();
  }

  Future<void> _loadTelemetry() async {
    final data = await _collarRepository.getCollarTelemetry('collar_001');
    if (mounted) {
      setState(() {
        _telemetry = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final geofenceStatus = _telemetry['geofence_status'] ?? 'SAFE';
    final battery = _telemetry['battery_level'] ?? 94;

    return Scaffold(
      appBar: AppBar(title: const Text('Live GPS Collar Radar')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Container(
                  color: const Color(0xFF1E293B),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 240,
                          height: 240,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primaryTeal.withOpacity(0.4), width: 2),
                          ),
                          child: Center(
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryTeal.withOpacity(0.15),
                              ),
                              child: const Icon(Icons.pets, size: 48, color: AppColors.secondaryCyan),
                            ),
                          ),
                        ),
                        AppSpacing.gapLg,
                        Text(
                          'Luna is inside Home Geofence ($geofenceStatus)',
                          style: AppTypography.titleLarge(context).copyWith(color: Colors.white),
                        ),
                        Text(
                          'GPS Accuracy: ±1.2 meters • Battery: $battery%',
                          style: AppTypography.monoData(context, color: AppColors.secondaryFixedDim),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 24,
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                  child: GlassContainer(
                    child: Row(
                      children: [
                        const Icon(Icons.security, color: AppColors.successGreen, size: 32),
                        AppSpacing.gapMd,
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Geofence Alert Active', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                              Text('Automatic broadcast to nearby rescuers if breached.', style: TextStyle(fontSize: 12, color: Colors.white70)),
                            ],
                          ),
                        ),
                        Switch(value: true, onChanged: (v) {}),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
