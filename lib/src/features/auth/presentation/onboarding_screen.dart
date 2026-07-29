import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/widgets/glass_container.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'AI Vitals & Smart Telemetry',
      'description': 'Continuous health monitoring powered by Smart Collar sensors and medical-grade AI diagnostic algorithms.',
      'icon': 'monitor_heart',
    },
    {
      'title': 'Instant AI Scan & Noseprint ID',
      'description': 'Identify strays, detect skin lesions, and scan medical documents instantly using computer vision.',
      'icon': 'center_focus_strong',
    },
    {
      'title': 'Unified Multi-Portal Ecosystem',
      'description': 'Seamless collaboration between Pet Owners, Veterinarians, Rescuers, and Administrators.',
      'icon': 'hub',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Container(
                padding: AppSpacing.paddingXl,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.lightBackground, Color(0xFFEFF4FF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GlassContainer(
                      width: 200,
                      height: 200,
                      borderRadius: 100,
                      child: Center(
                        child: Icon(
                          index == 0
                              ? Icons.monitor_heart
                              : index == 1
                                  ? Icons.center_focus_strong
                                  : Icons.hub,
                          size: 80,
                          color: AppColors.primaryTeal,
                        ),
                      ),
                    ),
                    AppSpacing.gapXl,
                    Text(
                      page['title']!,
                      textAlign: TextAlign.center,
                      style: AppTypography.headlineLarge(context),
                    ),
                    AppSpacing.gapMd,
                    Text(
                      page['description']!,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyLarge(context),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 40,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 6),
                      width: _currentIndex == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentIndex == index ? AppColors.primaryTeal : AppColors.lightOutlineVariant,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                    ),
                  ),
                  onPressed: () {
                    if (_currentIndex < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      context.go(AppRoutes.login);
                    }
                  },
                  child: Text(_currentIndex == _pages.length - 1 ? 'Get Started' : 'Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
