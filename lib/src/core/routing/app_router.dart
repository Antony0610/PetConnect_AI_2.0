import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/admin_command_center_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/profile_setup_screen.dart';
import '../../features/auth/presentation/role_selection_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/health_passport/presentation/health_passport_screen.dart';
import '../../features/pet_owner/presentation/pet_owner_dashboard_screen.dart';
import '../../features/rescue/presentation/live_rescue_map_screen.dart';
import '../../features/rescue/presentation/rescue_missions_hub_screen.dart';
import '../../features/smart_collar/presentation/live_tracking_screen.dart';
import '../../features/smart_collar/presentation/smart_collar_setup_screen.dart';
import '../../features/vet/presentation/clinical_dashboard_screen.dart';
import '../../features/volunteer/presentation/volunteer_dashboard_screen.dart';
import '../../features/ai_assistant/presentation/interactive_ai_chat_screen.dart';
import '../../features/ai_scan/presentation/ai_scan_screen.dart';

abstract class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String roleSelection = '/role-selection';
  static const String login = '/login';
  static const String profileSetup = '/profile-setup';
  
  static const String petOwnerDashboard = '/pet-owner';
  static const String healthPassport = '/pet-owner/health-passport';
  static const String smartCollarSetup = '/pet-owner/smart-collar';
  static const String liveTracking = '/pet-owner/live-tracking';
  static const String aiScan = '/pet-owner/ai-scan';
  static const String aiChat = '/pet-owner/ai-chat';
  
  static const String vetDashboard = '/vet';
  static const String volunteerDashboard = '/volunteer';
  static const String rescueHub = '/volunteer/rescue';
  static const String rescueMap = '/volunteer/rescue-map';
  
  static const String adminDashboard = '/admin';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.roleSelection,
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.profileSetup,
      builder: (context, state) => const ProfileSetupScreen(),
    ),
    GoRoute(
      path: AppRoutes.petOwnerDashboard,
      builder: (context, state) => const PetOwnerDashboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.healthPassport,
      builder: (context, state) => const HealthPassportScreen(),
    ),
    GoRoute(
      path: AppRoutes.smartCollarSetup,
      builder: (context, state) => const SmartCollarSetupScreen(),
    ),
    GoRoute(
      path: AppRoutes.liveTracking,
      builder: (context, state) => const LiveTrackingScreen(),
    ),
    GoRoute(
      path: AppRoutes.aiScan,
      builder: (context, state) => const AIScanScreen(),
    ),
    GoRoute(
      path: AppRoutes.aiChat,
      builder: (context, state) => const InteractiveAIChatScreen(),
    ),
    GoRoute(
      path: AppRoutes.vetDashboard,
      builder: (context, state) => const ClinicalDashboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.volunteerDashboard,
      builder: (context, state) => const VolunteerDashboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.rescueHub,
      builder: (context, state) => const RescueMissionsHubScreen(),
    ),
    GoRoute(
      path: AppRoutes.rescueMap,
      builder: (context, state) => const LiveRescueMapScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminDashboard,
      builder: (context, state) => const AdminCommandCenterScreen(),
    ),
  ],
);
