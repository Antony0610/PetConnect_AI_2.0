import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/security/secure_storage_service.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/app_drawer.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailAlerts = true;
  bool _smsAlerts = false;
  bool _biometricLock = true;
  String _selectedLanguage = 'English';

  final List<String> _languages = ['English', 'Spanish', 'French', 'German'];

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Settings'),
      ),
      drawer: const AppDrawer(currentRoute: '/settings'),
      body: FutureBuilder<SecureStorageService>(
        future: SecureStorageService.getInstance(),
        builder: (context, snapshot) {
          final storage = snapshot.data;
          final userData = storage?.getUserData() ?? {};
          final name = userData['name'] ?? 'PetConnect User';
          final email = userData['email'] ?? 'user@petconnect.ai';

          return ListView(
            padding: AppSpacing.paddingLg,
            children: [
              // User Profile Header Card
              Container(
                padding: AppSpacing.paddingMd,
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryTeal.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.primaryTeal,
                      child: Icon(Icons.person, color: Colors.white, size: 36),
                    ),
                    AppSpacing.gapMd,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(email, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppColors.primaryTeal),
                      onPressed: () => _showEditProfileModal(context, name, email, storage),
                    ),
                  ],
                ),
              ),
              AppSpacing.gapLg,

              // Section: Appearance & Theme
              const Text('Appearance', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal)),
              AppSpacing.gapSm,
              SwitchListTile(
                secondary: const Icon(Icons.dark_mode_outlined, color: AppColors.primaryTeal),
                title: const Text('Dark Mode'),
                subtitle: const Text('Enable OLED dark theme for low light environments'),
                value: themeMode == ThemeMode.dark,
                onChanged: (val) {
                  ref.read(themeModeProvider.notifier).toggleDarkMode(val);
                },
              ),
              ListTile(
                leading: const Icon(Icons.language, color: AppColors.primaryTeal),
                title: const Text('Language'),
                subtitle: Text(_selectedLanguage),
                trailing: DropdownButton<String>(
                  value: _selectedLanguage,
                  underline: const SizedBox(),
                  items: _languages.map((lang) {
                    return DropdownMenuItem(value: lang, child: Text(lang));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedLanguage = val);
                    }
                  },
                ),
              ),
              const Divider(),

              // Section: Security & Biometrics
              const Text('Security & Password', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal)),
              AppSpacing.gapSm,
              ListTile(
                leading: const Icon(Icons.lock_outline, color: AppColors.primaryTeal),
                title: const Text('Change Password'),
                subtitle: const Text('Update your account password'),
                onTap: () => _showChangePasswordModal(context),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.fingerprint, color: AppColors.primaryTeal),
                title: const Text('Biometric Authentication'),
                subtitle: const Text('Use FaceID / Fingerprint for quick app unlock'),
                value: _biometricLock,
                onChanged: (val) => setState(() => _biometricLock = val),
              ),
              const Divider(),

              // Section: Notifications Preferences
              const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal)),
              AppSpacing.gapSm,
              SwitchListTile(
                secondary: const Icon(Icons.notifications_active_outlined, color: AppColors.primaryTeal),
                title: const Text('Push Notifications'),
                subtitle: const Text('Geofence alerts, scan results & reminders'),
                value: _pushNotifications,
                onChanged: (val) => setState(() => _pushNotifications = val),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.email_outlined, color: AppColors.primaryTeal),
                title: const Text('Email Alerts'),
                subtitle: const Text('Receive health passport backups & monthly summaries'),
                value: _emailAlerts,
                onChanged: (val) => setState(() => _emailAlerts = val),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.sms_outlined, color: AppColors.primaryTeal),
                title: const Text('SMS Urgent Alerts'),
                subtitle: const Text('Receive SMS notifications during Lost Mode / SOS'),
                value: _smsAlerts,
                onChanged: (val) => setState(() => _smsAlerts = val),
              ),
              const Divider(),

              // Section: About & Support
              const Text('About & Support', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal)),
              AppSpacing.gapSm,
              const ListTile(
                leading: Icon(Icons.info_outline, color: AppColors.primaryTeal),
                title: Text('App Version'),
                subtitle: Text('1.0.0+1 (Production Release)'),
              ),
              ListTile(
                leading: const Icon(Icons.feedback_outlined, color: AppColors.primaryTeal),
                title: const Text('Send App Feedback'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Thank you! Feedback form submitted to product team.')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.support_agent, color: AppColors.primaryTeal),
                title: const Text('Contact Support Team'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Connecting to 24/7 PetConnect Support...')),
                  );
                },
              ),
              const Divider(),

              // Section: Account Actions
              const Text('Account Actions', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.errorRed)),
              AppSpacing.gapSm,
              ListTile(
                leading: const Icon(Icons.pause_circle_outline, color: AppColors.errorRed),
                title: const Text('Deactivate Account', style: TextStyle(color: AppColors.errorRed)),
                subtitle: const Text('Temporarily pause your account'),
                onTap: () => _confirmAccountAction(context, 'Deactivate', 'Deactivate your account temporarily? You can log back in anytime.'),
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: AppColors.errorRed),
                title: const Text('Delete Account', style: TextStyle(color: AppColors.errorRed, fontWeight: FontWeight.bold)),
                subtitle: const Text('Permanently delete account, pets, and medical history'),
                onTap: () => _confirmAccountAction(context, 'Delete', 'Are you sure you want to permanently delete your account? This action CANNOT be undone.'),
              ),
              AppSpacing.gapLg,
            ],
          );
        },
      ),
    );
  }

  void _showEditProfileModal(BuildContext context, String currentName, String currentEmail, SecureStorageService? storage) {
    final nameCtrl = TextEditingController(text: currentName);
    final emailCtrl = TextEditingController(text: currentEmail);
    final phoneCtrl = TextEditingController(text: storage?.getUserData()['phone'] ?? '+1 555-0199');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit Profile Information', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            AppSpacing.gapLg,
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
            ),
            AppSpacing.gapMd,
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email Address', border: OutlineInputBorder()),
            ),
            AppSpacing.gapMd,
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
            ),
            AppSpacing.gapLg,
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  if (storage != null) {
                    await storage.saveUserData(
                      uid: storage.getUserData()['uid'] ?? 'u123',
                      email: emailCtrl.text.trim(),
                      name: nameCtrl.text.trim(),
                      role: storage.getSelectedRole(),
                      phone: phoneCtrl.text.trim(),
                    );
                  }
                  if (ctx.mounted) {
                    Navigator.pop(ctx);
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated successfully!')),
                    );
                  }
                },
                child: const Text('Save Profile Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordModal(BuildContext context) {
    final currentPass = TextEditingController();
    final newPass = TextEditingController();
    final confirmPass = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Change Account Password', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            AppSpacing.gapLg,
            TextField(
              controller: currentPass,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password', border: OutlineInputBorder()),
            ),
            AppSpacing.gapMd,
            TextField(
              controller: newPass,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password', border: OutlineInputBorder()),
            ),
            AppSpacing.gapMd,
            TextField(
              controller: confirmPass,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm New Password', border: OutlineInputBorder()),
            ),
            AppSpacing.gapLg,
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (newPass.text != confirmPass.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('New passwords do not match!')),
                    );
                    return;
                  }
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password changed successfully!')),
                  );
                },
                child: const Text('Update Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmAccountAction(BuildContext context, String actionTitle, String body) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(actionTitle),
        content: Text(body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed, foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(ctx);
              final storage = await SecureStorageService.getInstance();
              await storage.clearAll();
              if (context.mounted) {
                context.go(AppRoutes.login);
              }
            },
            child: Text(actionTitle),
          ),
        ],
      ),
    );
  }
}
