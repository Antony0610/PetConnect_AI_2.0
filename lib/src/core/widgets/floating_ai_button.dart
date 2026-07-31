import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../routing/app_router.dart';

/// Single Circular Floating AI Button for PetConnect AI Ecosystem
class FloatingAIButton extends StatelessWidget {
  const FloatingAIButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'floating_ai_assistant_fab_circular',
      onPressed: () => context.go(AppRoutes.aiChat),
      backgroundColor: AppColors.primaryTeal,
      elevation: 6,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.pets,
            color: Colors.white,
            size: 24,
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.black,
                size: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
