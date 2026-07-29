import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum StatusType { success, warning, error, info }

/// Reusable Status Chip Widget for PetConnect AI Ecosystem
class StatusChip extends StatelessWidget {
  final String label;
  final StatusType type;

  const StatusChip({
    super.key,
    required this.label,
    this.type = StatusType.info,
  });

  Color _getBgColor() {
    switch (type) {
      case StatusType.success:
        return AppColors.successGreen.withOpacity(0.15);
      case StatusType.warning:
        return AppColors.warningOrange.withOpacity(0.15);
      case StatusType.error:
        return AppColors.errorRed.withOpacity(0.15);
      case StatusType.info:
        return AppColors.secondaryCyan.withOpacity(0.15);
    }
  }

  Color _getFgColor() {
    switch (type) {
      case StatusType.success:
        return AppColors.successGreen;
      case StatusType.warning:
        return AppColors.warningOrange;
      case StatusType.error:
        return AppColors.errorRed;
      case StatusType.info:
        return AppColors.secondaryCyan;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getBgColor(),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: _getFgColor(),
        ),
      ),
    );
  }
}
