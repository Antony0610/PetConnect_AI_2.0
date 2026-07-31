import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/security/secure_storage_service.dart';
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
      'title': 'Smart Collar Telemetry',
      'description': 'Real-time GPS tracking, geofencing, daily activity graphs, battery status, and instant SOS alerts.',
      'icon': 'my_location',
    },
    {
      'title': 'AI Vision Diagnostics',
      'description': 'Capture skin photos or noseprints for instant disease predictions, confidence scores, and PDF medical reports.',
      'icon': 'center_focus_strong',
    },
    {
      'title': 'Connected Pet Ecosystem',
      'description': 'Seamless multi-portal collaboration connecting Pet Owners, Veterinarians, Field Volunteers, and Administrators.',
      'icon': 'hub',
    },
  ];

  void _finishOnboarding() async {
    final storage = await SecureStorageService.getInstance();
    await storage.setHasSeenOnboarding(true);
    if (mounted) {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: _finishOnboarding,
            child: const Text('Skip', style: TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GlassContainer(
                      width: 180,
                      height: 180,
                      borderRadius: 90,
                      child: Center(
                        child: Icon(
                          index == 0
                              ? Icons.my_location
                              : index == 1
                                  ? Icons.center_focus_strong
                                  : Icons.hub,
                          size: 72,
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
                      _finishOnboarding();
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
