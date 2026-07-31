import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../routing/app_router.dart';
import '../security/secure_storage_service.dart';
import 'shared_providers.dart';

class AppDrawer extends ConsumerWidget {
  final String currentRoute;

  const AppDrawer({
    super.key,
    required this.currentRoute,
  });

  String _getRoleTitle(String role) {
    switch (role) {
      case 'vet':
        return 'Veterinarian';
      case 'volunteer':
        return 'Volunteer / Rescue';
      case 'admin':
        return 'Administrator';
      case 'pet_owner':
      default:
        return 'Pet Owner';
    }
  }

  String _getDashboardRoute(String role) {
    switch (role) {
      case 'vet':
        return AppRoutes.vetDashboard;
      case 'volunteer':
        return AppRoutes.volunteerDashboard;
      case 'admin':
        return AppRoutes.adminDashboard;
      case 'pet_owner':
      default:
        return AppRoutes.petOwnerDashboard;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadNotificationsCountProvider);

    return FutureBuilder<SecureStorageService>(
      future: SecureStorageService.getInstance(),
      builder: (context, snapshot) {
        final storage = snapshot.data;
        final userData = storage?.getUserData() ?? {};
        final userName = userData['name'] ?? 'PetConnect User';
        final userEmail = userData['email'] ?? 'user@petconnect.ai';
        final role = storage?.getSelectedRole() ?? 'pet_owner';
        final dashboardRoute = _getDashboardRoute(role);

        return Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Image.asset(
                        'assets/images/logo.png',
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.pets,
                          color: AppColors.primaryTeal,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
                accountName: Text(
                  userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                accountEmail: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      userEmail,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getRoleTitle(role),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.dashboard_outlined, color: AppColors.primaryTeal),
                      title: const Text('Dashboard'),
                      selected: currentRoute == dashboardRoute,
                      onTap: () {
                        Navigator.pop(context);
                        context.go(dashboardRoute);
                      },
                    ),
                    ListTile(
                      leading: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(Icons.notifications_none, color: AppColors.primaryTeal),
                          if (unreadCount > 0)
                            Positioned(
                              right: -2,
                              top: -2,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.errorRed,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '$unreadCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      title: const Text('Notifications'),
                      selected: currentRoute == AppRoutes.notifications,
                      onTap: () {
                        Navigator.pop(context);
                        context.go(AppRoutes.notifications);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.search, color: AppColors.primaryTeal),
                      title: const Text('Global Search'),
                      selected: currentRoute == AppRoutes.globalSearch,
                      onTap: () {
                        Navigator.pop(context);
                        context.go(AppRoutes.globalSearch);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings_outlined, color: AppColors.primaryTeal),
                      title: const Text('Settings'),
                      selected: currentRoute == AppRoutes.settings,
                      onTap: () {
                        Navigator.pop(context);
                        context.go(AppRoutes.settings);
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.help_outline, color: AppColors.primaryTeal),
                      title: const Text('Help & Support'),
                      onTap: () {
                        Navigator.pop(context);
                        _showHelpDialog(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.info_outline, color: AppColors.primaryTeal),
                      title: const Text('About PetConnect AI'),
                      onTap: () {
                        Navigator.pop(context);
                        _showAboutDialog(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.primaryTeal),
                      title: const Text('Privacy Policy'),
                      onTap: () {
                        Navigator.pop(context);
                        _showLegalDialog(context, 'Privacy Policy', 'PetConnect AI is committed to protecting your biometric, medical, and GPS location telemetry data.');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.article_outlined, color: AppColors.primaryTeal),
                      title: const Text('Terms of Service'),
                      onTap: () {
                        Navigator.pop(context);
                        _showLegalDialog(context, 'Terms of Service', 'By using PetConnect AI Ecosystem, you agree to our veterinary telemetry and AI diagnostic usage terms.');
                      },
                    ),
                  ],
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.errorRed),
                title: const Text('Logout', style: TextStyle(color: AppColors.errorRed, fontWeight: FontWeight.bold)),
                onTap: () async {
                  Navigator.pop(context);
                  if (storage != null) {
                    await storage.clearAll();
                  }
                  if (context.mounted) {
                    context.go(AppRoutes.login);
                  }
                },
              ),
              AppSpacing.gapMd,
            ],
          ),
        );
      },
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.help, color: AppColors.primaryTeal),
            SizedBox(width: 8),
            Text('Help & Support'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Need assistance with PetConnect AI?', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• Smart Collar sync issues: Ensure Bluetooth is enabled.'),
            Text('• AI Scan: Capture photos in good lighting.'),
            Text('• Emergency SOS: Press and hold SOS button for 3s.'),
            SizedBox(height: 12),
            Text('Support Email: support@petconnect.ai'),
            Text('24/7 Helpline: +1 (800) 555-PETS'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.pets, color: AppColors.primaryTeal),
            SizedBox(width: 8),
            Text('About PetConnect AI'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PetConnect AI Ecosystem v1.0.0+1', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Medical-grade pet care, smart collar telemetry, AI vision diagnostics, and field rescue dispatch operating on Clean Architecture & Django REST backend.'),
            SizedBox(height: 12),
            Text('© 2026 PetConnect AI Inc. All rights reserved.'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showLegalDialog(BuildContext context, String title, String body) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }
}
