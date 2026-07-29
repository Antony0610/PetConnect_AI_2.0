import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/repositories/pets_repository.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/widgets/ai_insight_banner.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/pet_vitals_card.dart';

class PetOwnerDashboardScreen extends StatefulWidget {
  const PetOwnerDashboardScreen({super.key});

  @override
  State<PetOwnerDashboardScreen> createState() => _PetOwnerDashboardScreenState();
}

class _PetOwnerDashboardScreenState extends State<PetOwnerDashboardScreen> {
  final PetsRepository _petsRepository = PetsRepository();
  List<dynamic> _pets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    final pets = await _petsRepository.getMyPets();
    if (mounted) {
      setState(() {
        _pets = pets;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final petName = _pets.isNotEmpty ? _pets[0]['name'] ?? 'Luna' : 'Luna';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.primaryTeal,
              radius: 18,
              child: Icon(Icons.pets, size: 20, color: Colors.white),
            ),
            AppSpacing.gapSm,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$petName (Golden Retriever)', style: AppTypography.titleLarge(context)),
                Text('Smart Collar Connected • 94% Battery', style: AppTypography.labelLarge(context)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.switch_account),
            tooltip: 'Switch Portal',
            onPressed: () => context.go(AppRoutes.roleSelection),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: AppSpacing.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AIInsightBanner(
                    title: 'AI Vitals Diagnostic Normal',
                    description: '$petName\'s resting heart rate and activity metrics align with optimal breed parameters over the past 24 hours.',
                    confidenceScore: '98.4%',
                    onTapAction: () => context.go(AppRoutes.aiChat),
                  ),
                  AppSpacing.gapLg,
                  Text('Live Telemetry', style: AppTypography.headlineMedium(context)),
                  AppSpacing.gapMd,
                  const Row(
                    children: [
                      Expanded(
                        child: PetVitalsCard(
                          title: 'Heart Rate',
                          value: '78',
                          unit: 'BPM',
                          icon: Icons.favorite,
                          accentColor: AppColors.primaryTeal,
                          statusText: 'Optimal',
                        ),
                      ),
                      AppSpacing.gapMd,
                      Expanded(
                        child: PetVitalsCard(
                          title: 'Body Temp',
                          value: '101.4',
                          unit: '°F',
                          icon: Icons.thermostat,
                          accentColor: AppColors.secondaryCyan,
                          statusText: 'Normal',
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.gapMd,
                  const Row(
                    children: [
                      Expanded(
                        child: PetVitalsCard(
                          title: 'Daily Steps',
                          value: '8,420',
                          unit: 'steps',
                          icon: Icons.directions_walk,
                          accentColor: AppColors.primaryTeal,
                          statusText: '84% Goal',
                        ),
                      ),
                      AppSpacing.gapMd,
                      Expanded(
                        child: PetVitalsCard(
                          title: 'Sleep Rest',
                          value: '9.2',
                          unit: 'hrs',
                          icon: Icons.bedtime,
                          accentColor: AppColors.tertiaryCoral,
                          statusText: 'Restful',
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.gapLg,
                  Text('Quick Portal Services', style: AppTypography.headlineMedium(context)),
                  AppSpacing.gapMd,
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1.4,
                    children: [
                      _buildQuickActionCard(
                        context,
                        title: 'Health Passport',
                        subtitle: 'EHR & Vaccines',
                        icon: Icons.medical_information,
                        color: AppColors.primaryTeal,
                        onTap: () => context.go(AppRoutes.healthPassport),
                      ),
                      _buildQuickActionCard(
                        context,
                        title: 'AI Scan & Vision',
                        subtitle: 'Skin & Noseprint ID',
                        icon: Icons.center_focus_strong,
                        color: AppColors.secondaryCyan,
                        onTap: () => context.go(AppRoutes.aiScan),
                      ),
                      _buildQuickActionCard(
                        context,
                        title: 'Smart Collar GPS',
                        subtitle: 'Live Tracking',
                        icon: Icons.my_location,
                        color: AppColors.tertiaryCoral,
                        onTap: () => context.go(AppRoutes.liveTracking),
                      ),
                      _buildQuickActionCard(
                        context,
                        title: 'AI Care Assistant',
                        subtitle: 'Symptom Checker',
                        icon: Icons.chat_bubble_outline,
                        color: AppColors.primaryTeal,
                        onTap: () => context.go(AppRoutes.aiChat),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: AppSpacing.paddingMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            AppSpacing.gapSm,
            Text(title, style: AppTypography.titleLarge(context)),
            Text(subtitle, style: AppTypography.labelLarge(context)),
          ],
        ),
      ),
    );
  }
}
