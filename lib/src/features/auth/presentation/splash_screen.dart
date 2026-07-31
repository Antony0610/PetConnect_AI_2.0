import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/security/secure_storage_service.dart';
import '../../../core/widgets/glass_container.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSessionAndNavigate();
  }

  void _checkSessionAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;

    final storage = await SecureStorageService.getInstance();
    final token = storage.getAuthToken();
    final hasSeenOnboarding = storage.getHasSeenOnboarding();
    final role = storage.getSelectedRole();

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
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
    } else if (!hasSeenOnboarding) {
      context.go(AppRoutes.onboarding);
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.darkBackground, Color(0xFF003732), AppColors.primaryTeal],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GlassContainer(
                width: 120,
                height: 120,
                borderRadius: AppSpacing.radiusXl,
                padding: EdgeInsets.zero,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryTeal,
                    ),
                    child: const Icon(
                      Icons.pets,
                      size: 48,
                      color: AppColors.onPrimary,
                    ),
                  ),
                ),
              )
                  .animate()
                  .scale(duration: 600.ms, curve: Curves.easeOut)
                  .shimmer(delay: 500.ms, duration: 800.ms),
              AppSpacing.gapLg,
              Text(
                'PetConnect AI',
                style: AppTypography.displayLarge(context).copyWith(
                  color: Colors.white,
                  letterSpacing: -1.0,
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.2, end: 0),
              AppSpacing.gapSm,
              Text(
                'Medical-Grade Intelligence for Pet Ecosystems',
                style: AppTypography.bodyMedium(context).copyWith(
                  color: AppColors.secondaryFixedDim,
                  letterSpacing: 0.5,
                ),
              ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
              AppSpacing.gapXl,
              const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryCyan),
                ),
              ).animate().fadeIn(delay: 800.ms),
            ],
          ),
        ),
      ),
    );
  }
}
