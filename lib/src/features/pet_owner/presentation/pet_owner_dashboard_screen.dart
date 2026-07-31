import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/repositories/pets_repository.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/widgets/ai_insight_banner.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/floating_ai_button.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/pet_vitals_card.dart';
import '../domain/pet_entity.dart';
import 'add_pet_screen.dart';
import 'pet_detail_screen.dart';

class PetOwnerDashboardScreen extends StatefulWidget {
  const PetOwnerDashboardScreen({super.key});

  @override
  State<PetOwnerDashboardScreen> createState() => _PetOwnerDashboardScreenState();
}

class _PetOwnerDashboardScreenState extends State<PetOwnerDashboardScreen> {
  final PetsRepository _petsRepository = PetsRepository();
  List<PetEntity> _pets = [];
  bool _isLoading = true;
  int _selectedPetIndex = 0;

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
    final activePet = _pets.isNotEmpty && _selectedPetIndex < _pets.length
        ? _pets[_selectedPetIndex]
        : null;

    final petName = activePet?.name ?? 'Luna';
    final breed = activePet?.breed ?? 'Golden Retriever';
    final battery = activePet?.vitals.batteryLevel ?? 94;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.primaryTeal,
              radius: 16,
              child: Icon(Icons.pets, size: 18, color: Colors.white),
            ),
            AppSpacing.gapSm,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$petName ($breed)', style: AppTypography.titleLarge(context)),
                Text('Smart Collar Connected • $battery% Battery', style: AppTypography.labelLarge(context)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.go(AppRoutes.globalSearch),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => context.go(AppRoutes.notifications),
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: AppRoutes.petOwnerDashboard),
      floatingActionButton: const FloatingAIButton(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPets,
              child: SingleChildScrollView(
                padding: AppSpacing.paddingLg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AI Insight Diagnostic Banner
                    AIInsightBanner(
                      title: 'AI Diagnostic Telemetry Optimal',
                      description: '$petName\'s daily step count and sleep rest cycle align with optimal breed health metrics over the last 24 hours.',
                      confidenceScore: '98.4%',
                      onTapAction: () => context.go(AppRoutes.aiChat),
                    ),
                    AppSpacing.gapLg,

                    // My Pets Carousel Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('My Registered Pets', style: AppTypography.headlineMedium(context)),
                        TextButton.icon(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AddPetScreen()),
                            );
                            if (result == true) {
                              _loadPets();
                            }
                          },
                          icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryTeal),
                          label: const Text('Add Pet', style: TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    AppSpacing.gapSm,

                    // Dynamic Pets Horizontal List
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _pets.length,
                        itemBuilder: (context, index) {
                          final pet = _pets[index];
                          final isSelected = index == _selectedPetIndex;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedPetIndex = index),
                            onDoubleTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => PetDetailScreen(petId: pet.id)),
                              );
                              if (result == true) _loadPets();
                            },
                            child: Container(
                              width: 220,
                              margin: const EdgeInsets.only(right: 12),
                              padding: AppSpacing.paddingSm,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryTeal.withOpacity(0.12)
                                    : Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? AppColors.primaryTeal : Colors.grey.shade300,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 26,
                                    backgroundColor: isSelected ? AppColors.primaryTeal : Colors.grey,
                                    child: const Icon(Icons.pets, color: Colors.white, size: 28),
                                  ),
                                  AppSpacing.gapSm,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(pet.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                        Text('${pet.breed} • ${pet.species}', style: const TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis),
                                        Text(pet.vaccinationStatus, style: const TextStyle(fontSize: 11, color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    AppSpacing.gapLg,

                    // Smart Collar Telemetry (Steps, Sleep, Active Time, Battery)
                    Text('Hardware Collar Telemetry', style: AppTypography.headlineMedium(context)),
                    AppSpacing.gapMd,
                    Row(
                      children: [
                        Expanded(
                          child: PetVitalsCard(
                            title: 'Daily Steps',
                            value: '${activePet?.vitals.dailySteps ?? 8420}',
                            unit: 'steps',
                            icon: Icons.directions_walk,
                            accentColor: AppColors.primaryTeal,
                            statusText: '84% Daily Goal',
                          ),
                        ),
                        AppSpacing.gapMd,
                        Expanded(
                          child: PetVitalsCard(
                            title: 'Sleep Duration',
                            value: '${activePet?.vitals.sleepHours ?? 9.2}',
                            unit: 'hrs',
                            icon: Icons.bedtime,
                            accentColor: AppColors.secondaryCyan,
                            statusText: 'Restful Sleep',
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapMd,
                    Row(
                      children: [
                        Expanded(
                          child: PetVitalsCard(
                            title: 'Active Minutes',
                            value: '${activePet?.vitals.activeMinutes ?? 145}',
                            unit: 'mins',
                            icon: Icons.bolt,
                            accentColor: AppColors.tertiaryCoral,
                            statusText: 'Active Play',
                          ),
                        ),
                        AppSpacing.gapMd,
                        Expanded(
                          child: PetVitalsCard(
                            title: 'Collar Battery',
                            value: '${activePet?.vitals.batteryLevel ?? 94}',
                            unit: '%',
                            icon: Icons.battery_charging_full,
                            accentColor: AppColors.primaryTeal,
                            statusText: 'Optimal Power',
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapLg,

                    // Services Grid
                    Text('Quick Portal Services', style: AppTypography.headlineMedium(context)),
                    AppSpacing.gapMd,
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: AppSpacing.md,
                      crossAxisSpacing: AppSpacing.md,
                      childAspectRatio: 1.3,
                      children: [
                        _buildQuickActionCard(
                          context,
                          title: 'Health Passport',
                          subtitle: 'EHR, Meds & Vaccines',
                          icon: Icons.medical_information,
                          color: AppColors.primaryTeal,
                          onTap: () => context.go(AppRoutes.healthPassport),
                        ),
                        _buildQuickActionCard(
                          context,
                          title: 'AI Scan & Vision',
                          subtitle: 'Laser Scan & Reports',
                          icon: Icons.center_focus_strong,
                          color: AppColors.secondaryCyan,
                          onTap: () => context.go(AppRoutes.aiScan),
                        ),
                        _buildQuickActionCard(
                          context,
                          title: 'Smart Collar GPS',
                          subtitle: 'Live Tracking & Geofence',
                          icon: Icons.my_location,
                          color: AppColors.tertiaryCoral,
                          onTap: () => context.go(AppRoutes.smartCollarSetup),
                        ),
                        _buildQuickActionCard(
                          context,
                          title: 'Nearby Vet Clinics',
                          subtitle: 'Find & Call Doctors',
                          icon: Icons.local_hospital,
                          color: AppColors.primaryTeal,
                          onTap: () => context.go(AppRoutes.nearbyVets),
                        ),
                      ],
                    ),
                  ],
                ),
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
