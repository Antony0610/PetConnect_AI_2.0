import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/routing/app_router.dart';
import '../data/auth_repository.dart';

class LoginScreen extends StatefulWidget {
  final String? initialRole;

  const LoginScreen({super.key, this.initialRole});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authRepository = AuthRepository();

  late String _selectedRole;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole ?? 'pet_owner';
    _emailController.text = 'owner@petconnect.ai';
    _passwordController.text = 'Password123!';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleAuthentication() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please enter valid email address and password.');
      return;
    }

    if (!email.contains('@')) {
      setState(() => _errorMessage = 'Please enter a valid email format.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _authRepository.login(
      email: email,
      password: password,
      role: _selectedRole,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication successful as ${_getRoleTitle(_selectedRole)}!')),
      );

      switch (_selectedRole) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PetConnect Identity Portal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.badge_outlined),
            tooltip: 'Choose Portal Role',
            onPressed: () => context.go(AppRoutes.roleSelection),
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
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Active Sign-In Role',
                prefixIcon: Icon(Icons.shield_outlined, color: AppColors.primaryTeal),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              items: const [
                DropdownMenuItem(value: 'pet_owner', child: Text('Pet Owner Portal')),
                DropdownMenuItem(value: 'vet', child: Text('Veterinarian Clinical Portal')),
                DropdownMenuItem(value: 'volunteer', child: Text('Volunteer & Rescue Portal')),
                DropdownMenuItem(value: 'admin', child: Text('Administrator Command Portal')),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedRole = val;
                    if (val == 'vet') {
                      _emailController.text = 'vet@petconnect.ai';
                    } else if (val == 'volunteer') {
                      _emailController.text = 'rescue@petconnect.ai';
                    } else if (val == 'admin') {
                      _emailController.text = 'admin@petconnect.ai';
                    } else {
                      _emailController.text = 'owner@petconnect.ai';
                    }
                  });
                }
              },
            ),
            AppSpacing.gapMd,
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
                  onPressed: () => context.go(AppRoutes.forgotPassword),
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
                    : Text('Authenticate as ${_getRoleTitle(_selectedRole)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            AppSpacing.gapMd,
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.register),
                    child: const Text('Create Account', style: TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
