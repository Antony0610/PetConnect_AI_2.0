import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/routing/app_router.dart';
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
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    if (mounted) {
      context.go(AppRoutes.onboarding);
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
                  .scale(duration: 800.ms, curve: Curves.elasticOut)
                  .shimmer(delay: 800.ms, duration: 1200.ms),
              AppSpacing.gapLg,
              Text(
                'PetConnect AI',
                style: AppTypography.displayLarge(context).copyWith(
                  color: Colors.white,
                  letterSpacing: -1.0,
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideY(begin: 0.2, end: 0),
              AppSpacing.gapSm,
              Text(
                'Medical-Grade Intelligence for Pet Ecosystems',
                style: AppTypography.bodyMedium(context).copyWith(
                  color: AppColors.secondaryFixedDim,
                  letterSpacing: 0.5,
                ),
              ).animate().fadeIn(delay: 700.ms, duration: 600.ms),
              AppSpacing.gapXl,
              const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryCyan),
                ),
              ).animate().fadeIn(delay: 1200.ms),
            ],
          ),
        ),
      ),
    );
  }
}
