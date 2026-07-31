import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/repositories/pets_repository.dart';
import '../../../core/widgets/glass_container.dart';
import '../domain/pet_entity.dart';
import 'add_pet_screen.dart';

class PetDetailScreen extends StatefulWidget {
  final String petId;

  const PetDetailScreen({super.key, required this.petId});

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  final _petsRepository = PetsRepository();
  PetEntity? _pet;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPet();
  }

  Future<void> _loadPet() async {
    final pet = await _petsRepository.getPetById(widget.petId);
    if (mounted) {
      setState(() {
        _pet = pet;
        _isLoading = false;
      });
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Pet Profile'),
        content: Text('Are you sure you want to delete ${_pet?.name}\'s profile? All health passport records and smart collar telemetry will be removed.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed, foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(ctx);
              if (_pet != null) {
                await _petsRepository.deletePet(_pet!.id);
              }
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${_pet?.name}\'s profile deleted.')),
                );
                context.pop(true);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pet Profile')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_pet == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pet Profile')),
        body: const Center(child: Text('Pet not found')),
      );
    }

    final pet = _pet!;

    return Scaffold(
      appBar: AppBar(
        title: Text('${pet.name}\'s Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Profile',
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddPetScreen(petToEdit: pet)),
              );
              if (result == true) {
                _loadPet();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.errorRed),
            tooltip: 'Delete Pet',
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 54,
                    backgroundColor: AppColors.primaryTeal,
                    child: Icon(Icons.pets, size: 64, color: Colors.white),
                  ),
                  AppSpacing.gapMd,
                  Text(pet.name, style: AppTypography.headlineLarge(context)),
                  Text('${pet.breed} • ${pet.species}', style: AppTypography.bodyMedium(context)),
                  AppSpacing.gapSm,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primaryTeal),
                    ),
                    child: Text(
                      'Vaccination: ${pet.vaccinationStatus}',
                      style: const TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapLg,

            // Attributes Grid
            Row(
              children: [
                Expanded(child: _buildInfoTile(context, 'Age', '${pet.ageYears} yrs', Icons.calendar_today)),
                AppSpacing.gapMd,
                Expanded(child: _buildInfoTile(context, 'Gender', pet.gender, Icons.wc)),
              ],
            ),
            AppSpacing.gapMd,
            Row(
              children: [
                Expanded(child: _buildInfoTile(context, 'Weight', '${pet.weightKg} kg', Icons.monitor_weight_outlined)),
                AppSpacing.gapMd,
                Expanded(child: _buildInfoTile(context, 'Color', pet.color, Icons.palette_outlined)),
              ],
            ),
            AppSpacing.gapLg,

            // Smart Collar Telemetry Summary
            Text('Smart Collar Telemetry', style: AppTypography.headlineMedium(context)),
            AppSpacing.gapMd,
            GlassContainer(
              padding: AppSpacing.paddingMd,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Daily Steps', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${pet.vitals.dailySteps} steps', style: const TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Sleep Duration', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${pet.vitals.sleepHours} hrs', style: const TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Battery Level', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${pet.vitals.batteryLevel}%', style: const TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('GPS Lock', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(pet.vitals.gpsStatus, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.gapLg,

            // Medical Notes & Emergency Contact
            Text('Medical Notes & History', style: AppTypography.headlineMedium(context)),
            AppSpacing.gapMd,
            Container(
              width: double.infinity,
              padding: AppSpacing.paddingMd,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkSurfaceContainer
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(pet.medicalNotes.isEmpty ? 'No medical notes documented.' : pet.medicalNotes),
            ),
            AppSpacing.gapLg,

            // Emergency Contact Card
            Container(
              padding: AppSpacing.paddingMd,
              decoration: BoxDecoration(
                color: AppColors.tertiaryCoral.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.tertiaryCoral.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.tertiaryCoral,
                    child: Icon(Icons.phone_in_talk, color: Colors.white),
                  ),
                  AppSpacing.gapMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Emergency Contact', style: AppTypography.labelLarge(context)),
                        Text(pet.emergencyContactName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(pet.emergencyContactPhone, style: const TextStyle(color: AppColors.tertiaryCoral)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tertiaryCoral,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Calling ${pet.emergencyContactName}...')),
                      );
                    },
                    child: const Text('Call'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, String label, String value, IconData icon) {
    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkSurfaceContainer
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryTeal, size: 22),
          AppSpacing.gapSm,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}
