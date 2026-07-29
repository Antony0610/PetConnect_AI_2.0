import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/repositories/rescue_repository.dart';
import '../../../core/widgets/glass_container.dart';

class LiveRescueMapScreen extends StatefulWidget {
  const LiveRescueMapScreen({super.key});

  @override
  State<LiveRescueMapScreen> createState() => _LiveRescueMapScreenState();
}

class _LiveRescueMapScreenState extends State<LiveRescueMapScreen> with SingleTickerProviderStateMixin {
  final RescueRepository _rescueRepository = RescueRepository();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  List<dynamic> _missions = [];
  bool _isLoading = true;
  bool _isSatellite = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _loadMissions();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadMissions() async {
    final missions = await _rescueRepository.getActiveMissions();
    if (mounted) {
      setState(() {
        _missions = missions;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Rescue Radar Map'),
        actions: [
          IconButton(
            icon: Icon(_isSatellite ? Icons.map : Icons.satellite_alt),
            tooltip: 'Toggle Satellite Mode',
            onPressed: () {
              setState(() => _isSatellite = !_isSatellite);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.errorRed))
          : Stack(
              children: [
                // Radar Map Canvas
                Container(
                  color: _isSatellite ? const Color(0xFF0F172A) : const Color(0xFF1E293B),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Container(
                              width: 220 * _pulseAnimation.value,
                              height: 220 * _pulseAnimation.value,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.errorRed.withOpacity(0.4 / _pulseAnimation.value),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.errorRed.withOpacity(0.15),
                                    border: Border.all(color: AppColors.tertiaryCoral, width: 2),
                                  ),
                                  child: const Icon(Icons.warning_amber, size: 48, color: AppColors.tertiaryCoral),
                                ),
                              ),
                            );
                          },
                        ),
                        AppSpacing.gapLg,
                        Text(
                          'Active Dispatch Radius: 5.0 km',
                          style: AppTypography.titleLarge(context).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${_missions.length} Active Missions • 14 Rescuers Online',
                          style: AppTypography.monoData(context, color: AppColors.secondaryFixedDim),
                        ),
                      ],
                    ),
                  ),
                ),

                // Search Bar Overlay
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: GlassContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.white70),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text('Search sector or incident ID...', style: TextStyle(color: Colors.white70)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.my_location, color: AppColors.secondaryCyan),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('GPS Lock: Re-centered on Emergency Zone')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Draggable Bottom Mission Sheet
                DraggableScrollableSheet(
                  initialChildSize: 0.28,
                  minChildSize: 0.15,
                  maxChildSize: 0.65,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF0F172A),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 20)],
                      ),
                      child: ListView.builder(
                        controller: scrollController,
                        padding: AppSpacing.paddingLg,
                        itemCount: _missions.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Column(
                              children: [
                                Container(
                                  width: 40,
                                  height: 4,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Active Rescue Incidents', style: AppTypography.headlineMedium(context)),
                                    Chip(
                                      backgroundColor: AppColors.errorRed.withOpacity(0.2),
                                      label: Text('${_missions.length} Urgent', style: const TextStyle(color: AppColors.errorRed, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                              ],
                            );
                          }

                          final m = _missions[index - 1];
                          return Card(
                            color: Colors.white10,
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: AppColors.errorRed,
                                child: Icon(Icons.pets, color: Colors.white),
                              ),
                              title: Text(m['title'] ?? 'Stray Emergency', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              subtitle: Text(m['location'] ?? '0.8 km away', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Accepted Mission: ${m['title']}')),
                                  );
                                },
                                child: const Text('Accept', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
