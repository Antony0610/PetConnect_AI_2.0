import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/widgets/role_selector_card.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String _selectedRole = 'pet_owner';

  void _navigateToRole(String role) {
    switch (role) {
      case 'pet_owner':
        context.go(AppRoutes.petOwnerDashboard);
        break;
      case 'vet':
        context.go(AppRoutes.vetDashboard);
        break;
      case 'volunteer':
        context.go(AppRoutes.volunteerDashboard);
        break;
      case 'admin':
        context.go(AppRoutes.adminDashboard);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select User Portal'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAlignment.start,
            children: [
              Text(
                'Choose Your Role',
                style: AppTypography.headlineLarge(context),
              ),
              AppSpacing.gapXs,
              Text(
                'Access customized dashboards, clinical tools, or rescue mission controls.',
                style: AppTypography.bodyMedium(context),
              ),
              AppSpacing.gapLg,
              Expanded(
                child: ListView(
                  children: [
                    RoleSelectorCard(
                      roleKey: 'pet_owner',
                      title: 'Pet Owner Portal',
                      description: 'Track vitals, manage health passports, Smart Collar geofencing, and AI symptom assistant.',
                      icon: Icons.pets,
                      isSelected: _selectedRole == 'pet_owner',
                      onTap: () => setState(() => _selectedRole = 'pet_owner'),
                    ),
                    RoleSelectorCard(
                      roleKey: 'vet',
                      title: 'Veterinarian Portal',
                      description: 'Clinical EHR records, teleconsultations, digital Rx generator, and lab diagnostics.',
                      icon: Icons.medical_services,
                      isSelected: _selectedRole == 'vet',
                      onTap: () => setState(() => _selectedRole = 'vet'),
                    ),
                    RoleSelectorCard(
                      roleKey: 'volunteer',
                      title: 'Volunteer & Rescue Portal',
                      description: 'Live incident dispatch, stray noseprint matching, adoption applications, and events.',
                      icon: Icons.volunteer_activism,
                      isSelected: _selectedRole == 'volunteer',
                      onTap: () => setState(() => _selectedRole = 'volunteer'),
                    ),
                    RoleSelectorCard(
                      roleKey: 'admin',
                      title: 'Administrator Portal',
                      description: 'Whole-platform telemetry, user management, audit logs, revenue, and fleet OTA.',
                      icon: Icons.admin_panel_settings,
                      isSelected: _selectedRole == 'admin',
                      onTap: () => setState(() => _selectedRole = 'admin'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                    ),
                  ),
                  onPressed: () => _navigateToRole(_selectedRole),
                  child: const Text(
                    'Continue to Selected Portal',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
