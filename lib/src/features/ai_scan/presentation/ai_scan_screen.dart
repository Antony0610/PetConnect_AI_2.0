import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/repositories/ai_repository.dart';
import '../../../core/widgets/glass_container.dart';

class AIScanScreen extends StatefulWidget {
  const AIScanScreen({super.key});

  @override
  State<AIScanScreen> createState() => _AIScanScreenState();
}

class _AIScanScreenState extends State<AIScanScreen> {
  final AIRepository _aiRepository = AIRepository();
  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysisResult;

  Future<void> _triggerScan(String mode) async {
    setState(() => _isAnalyzing = true);
    final result = await _aiRepository.analyzeImage('sample.jpg', mode);
    if (mounted) {
      setState(() {
        _analysisResult = result;
        _isAnalyzing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Vision Scanner')),
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            child: Center(
              child: _isAnalyzing
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColors.secondaryCyan),
                        SizedBox(height: 16),
                        Text('Analyzing Vision Features...', style: TextStyle(color: Colors.white)),
                      ],
                    )
                  : Container(
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
          onPressed: () => _triggerScan(label),
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
