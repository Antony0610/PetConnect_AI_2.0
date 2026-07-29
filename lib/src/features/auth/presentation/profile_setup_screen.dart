import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/widgets/glass_container.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController(text: 'Alex Morgan');
  final _phoneController = TextEditingController(text: '+1 (555) 234-5678');
  final _addressController = TextEditingController(text: '742 Evergreen Terrace, Sector 4');
  bool _notificationsEnabled = true;
  bool _locationSharing = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Profile & Preferences'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Save Profile',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile preferences saved to backend database!')),
              );
              context.go(AppRoutes.petOwnerDashboard);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Card
            GlassContainer(
              padding: AppSpacing.paddingLg,
              child: Row(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 36,
                        backgroundColor: AppColors.primaryTeal,
                        child: Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: AppColors.secondaryCyan, shape: BoxShape.circle),
                          child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.gapMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Alex Morgan', style: AppTypography.titleLarge(context)),
                        const Text('alex@petconnect.ai', style: TextStyle(color: Colors.white70)),
                        const SizedBox(height: 4),
                        Chip(
                          backgroundColor: AppColors.primaryTeal.withOpacity(0.2),
                          label: const Text('Verified Pet Owner', style: TextStyle(color: AppColors.primaryTeal, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapLg,

            Text('Account Information', style: AppTypography.headlineMedium(context)),
            AppSpacing.gapMd,
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Display Name',
                prefixIcon: Icon(Icons.person_outline, color: AppColors.primaryTeal),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            AppSpacing.gapMd,
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Emergency Contact Phone',
                prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primaryTeal),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            AppSpacing.gapMd,
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Primary Residence Address',
                prefixIcon: Icon(Icons.home_outlined, color: AppColors.primaryTeal),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            AppSpacing.gapLg,

            Text('System Preferences', style: AppTypography.headlineMedium(context)),
            AppSpacing.gapMd,
            GlassContainer(
              child: SwitchListTile(
                activeColor: AppColors.primaryTeal,
                title: const Text('Push & SMS Emergency Alerts'),
                subtitle: const Text('Receive instant geofence breach & rescue notifications'),
                value: _notificationsEnabled,
                onChanged: (v) => setState(() => _notificationsEnabled = v),
              ),
            ),
            AppSpacing.gapSm,
            GlassContainer(
              child: SwitchListTile(
                activeColor: AppColors.primaryTeal,
                title: const Text('Background Location Sharing'),
                subtitle: const Text('Required for live Smart Collar GPS radar sync'),
                value: _locationSharing,
                onChanged: (v) => setState(() => _locationSharing = v),
              ),
            ),
            AppSpacing.gapLg,

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile saved successfully! Redirecting...')),
                  );
                  context.go(AppRoutes.petOwnerDashboard);
                },
                child: const Text('Save & Continue to Dashboard', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
