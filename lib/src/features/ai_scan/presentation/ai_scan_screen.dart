import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/glass_container.dart';

class AIScanScreen extends StatelessWidget {
  const AIScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Vision Scanner')),
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            child: Center(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: AppColors.secondaryCyan, width: 3),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.center_focus_weak, size: 64, color: AppColors.secondaryCyan),
                    SizedBox(height: 12),
                    Text('Align noseprint or skin lesion inside box', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            child: GlassContainer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildScanModeButton(context, 'Noseprint ID', Icons.fingerprint, true),
                  _buildScanModeButton(context, 'Skin Lesion', Icons.healing, false),
                  _buildScanModeButton(context, 'Document OCR', Icons.document_scanner, false),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildScanModeButton(BuildContext context, String label, IconData icon, bool isActive) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: isActive ? AppColors.secondaryCyan : Colors.grey, size: 32),
          onPressed: () {},
        ),
        Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.secondaryCyan : Colors.grey,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
