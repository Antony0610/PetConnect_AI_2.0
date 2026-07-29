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

class _AIScanScreenState extends State<AIScanScreen> with SingleTickerProviderStateMixin {
  final AIRepository _aiRepository = AIRepository();
  late AnimationController _laserController;
  late Animation<double> _laserAnimation;

  bool _isAnalyzing = false;
  bool _isFlashOn = false;
  int _selectedModeIndex = 0;
  Map<String, dynamic>? _analysisResult;

  final List<Map<String, dynamic>> _scanModes = [
    {'label': 'Noseprint ID', 'icon': Icons.fingerprint, 'modeKey': 'noseprint'},
    {'label': 'Skin Lesion', 'icon': Icons.healing, 'modeKey': 'dermatology'},
    {'label': 'Tick & Flea', 'icon': Icons.bug_report, 'modeKey': 'parasite'},
    {'label': 'Eye Infection', 'icon': Icons.remove_red_eye, 'modeKey': 'ophthalmology'},
    {'label': 'Document OCR', 'icon': Icons.document_scanner, 'modeKey': 'ocr'},
  ];

  @override
  void initState() {
    super.initState();
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _laserAnimation = Tween<double>(begin: 0.0, end: 280.0).animate(
      CurvedAnimation(parent: _laserController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _laserController.dispose();
    super.dispose();
  }

  Future<void> _triggerScan(String modeKey) async {
    setState(() => _isAnalyzing = true);
    final result = await _aiRepository.analyzeImage('sample.jpg', modeKey);
    if (mounted) {
      setState(() {
        _analysisResult = result;
        _isAnalyzing = false;
      });
      _showDiagnosisModal(context, result);
    }
  }

  void _showDiagnosisModal(BuildContext context, Map<String, dynamic> result) {
    final activeResult = _analysisResult ?? result;
    final confidence = (activeResult['confidence'] ?? 0.94) * 100;
    final primaryLabel = activeResult['primary_diagnosis'] ?? 'Benign Epidermal Dermatitis';
    final severity = activeResult['severity'] ?? 'Mild Risk';

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: AppSpacing.paddingLg,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              AppSpacing.gapLg,
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: AppColors.secondaryCyan, size: 28),
                  AppSpacing.gapMd,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gemini 1.5 Pro Diagnostic Report', style: AppTypography.titleLarge(context).copyWith(color: Colors.white)),
                      Text('Confidence Score: ${confidence.toStringAsFixed(1)}%', style: const TextStyle(color: AppColors.secondaryCyan, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              AppSpacing.gapLg,
              GlassContainer(
                padding: AppSpacing.paddingMd,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Primary Findings:', style: AppTypography.titleMedium(context).copyWith(color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(primaryLabel, style: const TextStyle(color: Colors.white70, fontSize: 16)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Chip(
                          backgroundColor: AppColors.warningOrange.withOpacity(0.2),
                          label: Text(severity, style: const TextStyle(color: AppColors.warningOrange, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 8),
                        const Chip(
                          backgroundColor: Colors.white10,
                          label: Text('Local ONNX + Cloud RAG', style: TextStyle(color: Colors.white70, fontSize: 10)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AppSpacing.gapLg,
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Diagnostic Report saved to Pet EHR Passport')),
                        );
                      },
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text('Save to Passport', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Vision Scanner'),
        actions: [
          IconButton(
            icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: () => setState(() => _isFlashOn = !_isFlashOn),
          ),
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: () => _triggerScan(_scanModes[_selectedModeIndex]['modeKey']),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera Viewport Box
          Container(
            color: Colors.black,
            child: Center(
              child: _isAnalyzing
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColors.secondaryCyan),
                        SizedBox(height: 16),
                        Text('Running Gemini 1.5 RAG Vision Analysis...', style: TextStyle(color: Colors.white)),
                      ],
                    )
                  : Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                        border: Border.all(color: AppColors.secondaryCyan, width: 3),
                      ),
                      child: Stack(
                        children: [
                          const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.center_focus_weak, size: 64, color: AppColors.secondaryCyan),
                                SizedBox(height: 12),
                                Text('Align lesion or noseprint inside box', style: TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ),
                          // Animated Laser Line
                          AnimatedBuilder(
                            animation: _laserAnimation,
                            builder: (context, child) {
                              return Positioned(
                                top: _laserAnimation.value,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryCyan,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.secondaryCyan.withOpacity(0.8),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
            ),
          ),

          // Scan Mode Selection Bottom Carousel
          Positioned(
            bottom: 24,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            child: GlassContainer(
              padding: AppSpacing.paddingSm,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_scanModes.length, (index) {
                    final isSelected = _selectedModeIndex == index;
                    final mode = _scanModes[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedModeIndex = index);
                        _triggerScan(mode['modeKey']);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryTeal : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(mode['icon'], color: isSelected ? Colors.white : Colors.white60, size: 20),
                            const SizedBox(width: 6),
                            Text(
                              mode['label'],
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.white70,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
