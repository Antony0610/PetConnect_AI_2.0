import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/routing/app_router.dart';
import '../data/auth_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _authRepository = AuthRepository();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _handleAuthentication() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please enter valid email credentials and password.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _authRepository.login(email: email, password: password);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication successful! Token acquired.')),
      );

      final role = result['role'] ?? 'pet_owner';
      switch (role) {
        case 'vet':
          context.go(AppRoutes.vetDashboard);
          break;
        case 'volunteer':
          context.go(AppRoutes.volunteerDashboard);
          break;
        case 'admin':
          context.go(AppRoutes.adminDashboard);
          break;
        case 'pet_owner':
        default:
          context.go(AppRoutes.petOwnerDashboard);
          break;
      }
    } else {
      setState(() => _errorMessage = result['error'] ?? 'Authentication failed. Verify credentials.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PetConnect Identity Portal'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryTeal,
          labelColor: AppColors.primaryTeal,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Sign In'),
            Tab(text: 'Create Account'),
          ],
        ),
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
                    radius: 36,
                    backgroundColor: AppColors.primaryTeal,
                    child: Icon(Icons.pets, size: 40, color: Colors.white),
                  ),
                  AppSpacing.gapMd,
                  Text('PetConnect AI Ecosystem', style: AppTypography.headlineLarge(context)),
                  Text('Medical-Grade PetCare & Smart Telemetry', style: AppTypography.bodyMedium(context)),
                ],
              ),
            ),
            AppSpacing.gapLg,
            if (_errorMessage != null) ...[
              Container(
                padding: AppSpacing.paddingMd,
                decoration: BoxDecoration(
                  color: AppColors.errorRed.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.errorRed),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.errorRed),
                    AppSpacing.gapSm,
                    Expanded(
                      child: Text(_errorMessage!, style: const TextStyle(color: AppColors.errorRed)),
                    ),
                  ],
                ),
              ),
              AppSpacing.gapMd,
            ],
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Account Email',
                prefixIcon: Icon(Icons.email_outlined, color: AppColors.primaryTeal),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            AppSpacing.gapMd,
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primaryTeal),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            AppSpacing.gapSm,
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  activeColor: AppColors.primaryTeal,
                  onChanged: (v) => setState(() => _rememberMe = v ?? true),
                ),
                const Text('Remember Credentials'),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password reset link dispatched to account email.')),
                    );
                  },
                  child: const Text('Forgot Password?', style: TextStyle(color: AppColors.primaryTeal)),
                ),
              ],
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
                onPressed: _isLoading ? null : _handleAuthentication,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Authenticate & Launch Portal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            AppSpacing.gapMd,
            Center(
              child: TextButton(
                onPressed: () => context.go(AppRoutes.roleSelection),
                child: const Text('Switch Role Portal', style: TextStyle(color: AppColors.primaryTeal)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
