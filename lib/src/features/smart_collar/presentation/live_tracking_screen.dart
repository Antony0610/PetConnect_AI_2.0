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

class _LiveTrackingScreenState extends State<LiveTrackingScreen> with SingleTickerProviderStateMixin {
  final CollarRepository _collarRepository = CollarRepository();
  late AnimationController _radarAnimationController;
  late Animation<double> _radarPulseAnimation;
  
  Map<String, dynamic> _telemetry = {};
  bool _isLoading = true;
  bool _geofenceEnabled = true;

  @override
  void initState() {
    super.initState();
    _radarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _radarPulseAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _radarAnimationController, curve: Curves.easeInOut),
    );

    _loadTelemetry();
  }

  @override
  void dispose() {
    _radarAnimationController.dispose();
    super.dispose();
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
    final lat = _telemetry['latitude'] ?? 37.7749;
    final lng = _telemetry['longitude'] ?? -122.4194;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live GPS Radar & Telemetry'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh GPS',
            onPressed: () {
              setState(() => _isLoading = true);
              _loadTelemetry();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
          : Stack(
              children: [
                // Radar Map Background
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _radarPulseAnimation,
                          builder: (context, child) {
                            return Container(
                              width: 260 * _radarPulseAnimation.value,
                              height: 260 * _radarPulseAnimation.value,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primaryTeal.withOpacity(0.35 / _radarPulseAnimation.value),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryTeal.withOpacity(0.15),
                                    blurRadius: 30,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryTeal.withOpacity(0.2),
                                    border: Border.all(color: AppColors.secondaryCyan, width: 2),
                                  ),
                                  child: const Icon(Icons.pets, size: 52, color: AppColors.secondaryCyan),
                                ),
                              ),
                            );
                          },
                        ),
                        AppSpacing.gapLg,
                        Text(
                          'Luna is inside Home Geofence ($geofenceStatus)',
                          style: AppTypography.titleLarge(context).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        AppSpacing.gapSm,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.secondaryCyan.withOpacity(0.5)),
                          ),
                          child: Text(
                            'GPS: $lat° N, $lng° W • Battery: $battery%',
                            style: AppTypography.monoData(context, color: AppColors.secondaryFixedDim),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Map Overlay Floating Action Controls
                Positioned(
                  top: 20,
                  right: 20,
                  child: Column(
                    children: [
                      FloatingActionButton.small(
                        heroTag: 'recenter',
                        backgroundColor: AppColors.primaryTeal,
                        foregroundColor: Colors.white,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Re-centered on Pet Location (GPS Lock: High accuracy)')),
                          );
                        },
                        child: const Icon(Icons.my_location),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton.small(
                        heroTag: 'zoom',
                        backgroundColor: Colors.white12,
                        foregroundColor: Colors.white,
                        onPressed: () {},
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),

                // Bottom Geofence Control Card
                Positioned(
                  bottom: 24,
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                  child: GlassContainer(
                    padding: AppSpacing.paddingMd,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.successGreen.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.security, color: AppColors.successGreen, size: 28),
                        ),
                        AppSpacing.gapMd,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Geofence Guard Active',
                                style: AppTypography.titleMedium(context).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Instant alert & volunteer dispatch on boundary exit.',
                                style: TextStyle(fontSize: 12, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _geofenceEnabled,
                          activeColor: AppColors.primaryTeal,
                          onChanged: (v) {
                            setState(() => _geofenceEnabled = v);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(v ? 'Geofence Guard Activated' : 'Geofence Guard Deactivated')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
