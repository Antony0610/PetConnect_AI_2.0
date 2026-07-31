import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../routing/app_router.dart';

class FloatingAIButton extends StatelessWidget {
  const FloatingAIButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'floating_ai_assistant_fab',
      onPressed: () => context.go(AppRoutes.aiChat),
      backgroundColor: AppColors.primaryTeal,
      elevation: 6,
      icon: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Colors.white24,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.psychology_outlined,
          color: Colors.white,
          size: 24,
        ),
      ),
      label: const Text(
        'AI Assistant',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
