import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/role_selector_card.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String _selectedRole = 'pet_owner';

  void _proceedToLogin(String role) {
    context.go('/login?role=$role');
  }

  void _proceedToRegister(String role) {
    context.go('/register?role=$role');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Portal Role'),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to PetConnect AI',
              style: AppTypography.headlineLarge(context),
            ),
            AppSpacing.gapSm,
            Text(
              'Select your role to access specialized features. Each role has separate authentication credentials.',
              style: AppTypography.bodyMedium(context),
            ),
            AppSpacing.gapLg,
            RoleSelectorCard(
              roleKey: 'pet_owner',
              title: 'Pet Owner Portal',
              description: 'Manage pet profiles, smart collar telemetry, AI vision scans, health passports & chat assistant.',
              icon: Icons.pets,
              isSelected: _selectedRole == 'pet_owner',
              onTap: () => setState(() => _selectedRole = 'pet_owner'),
            ),
            AppSpacing.gapMd,
            RoleSelectorCard(
              roleKey: 'vet',
              title: 'Veterinarian Clinical Hub',
              description: 'Consultations queue, digital prescription builder, medical EHR records & patient scheduling.',
              icon: Icons.medical_services,
              isSelected: _selectedRole == 'vet',
              onTap: () => setState(() => _selectedRole = 'vet'),
            ),
            AppSpacing.gapMd,
            RoleSelectorCard(
              roleKey: 'volunteer',
              title: 'Volunteer & Rescue Portal',
              description: 'Stray alerts feed, live dispatch map, duty radar, rescue mission tracking & community feed.',
              icon: Icons.volunteer_activism,
              isSelected: _selectedRole == 'volunteer',
              onTap: () => setState(() => _selectedRole = 'volunteer'),
            ),
            AppSpacing.gapMd,
            RoleSelectorCard(
              roleKey: 'admin',
              title: 'Administrator Command Center',
              description: 'System telemetry, user directory RBAC, remote feature flags, AI statistics & health probes.',
              icon: Icons.admin_panel_settings,
              isSelected: _selectedRole == 'admin',
              onTap: () => setState(() => _selectedRole = 'admin'),
            ),
            AppSpacing.gapXl,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppColors.primaryTeal),
                    ),
                    onPressed: () => _proceedToRegister(_selectedRole),
                    child: const Text('Create Account'),
                  ),
                ),
                AppSpacing.gapMd,
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryTeal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => _proceedToLogin(_selectedRole),
                    child: const Text('Sign In'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
