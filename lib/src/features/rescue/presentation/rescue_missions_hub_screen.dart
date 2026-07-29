import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/repositories/rescue_repository.dart';
import '../../../core/widgets/glass_container.dart';

class RescueMissionsHubScreen extends StatefulWidget {
  const RescueMissionsHubScreen({super.key});

  @override
  State<RescueMissionsHubScreen> createState() => _RescueMissionsHubScreenState();
}

class _RescueMissionsHubScreenState extends State<RescueMissionsHubScreen> {
  final RescueRepository _rescueRepository = RescueRepository();
  List<dynamic> _missions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMissions();
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
      appBar: AppBar(title: const Text('Rescue Incident Missions')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: AppSpacing.paddingLg,
              children: [
                GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.warning_amber, color: AppColors.errorRed, size: 28),
                          AppSpacing.gapSm,
                          Text('Incident #RS-9921', style: AppTypography.titleLarge(context)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: AppColors.errorRed, borderRadius: BorderRadius.circular(4)),
                            child: const Text('CRITICAL', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      AppSpacing.gapSm,
                      Text('Injured Stray Dog Reported near Highway Exit 4', style: AppTypography.bodyLarge(context)),
                      Text('Reported by Citizen • Coordinates: 40.7128° N, 74.0060° W', style: AppTypography.labelLarge(context)),
                      AppSpacing.gapMd,
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal, foregroundColor: Colors.white),
                        onPressed: () {},
                        child: const Text('Accept Mission & Dispatch Squad'),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
