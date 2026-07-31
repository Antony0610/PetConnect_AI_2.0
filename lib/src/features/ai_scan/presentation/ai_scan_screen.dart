import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/glass_container.dart';

class AIScanScreen extends StatefulWidget {
  const AIScanScreen({super.key});

  @override
  State<AIScanScreen> createState() => _AIScanScreenState();
}

class _AIScanScreenState extends State<AIScanScreen> with SingleTickerProviderStateMixin {
  late AnimationController _laserController;
  late Animation<double> _laserAnimation;

  bool _isAnalyzing = false;
  bool _isFlashOn = false;
  int _selectedModeIndex = 1;

  final List<Map<String, dynamic>> _scanModes = [
    {'label': 'Noseprint ID', 'icon': Icons.fingerprint, 'modeKey': 'noseprint'},
    {'label': 'Skin Lesion', 'icon': Icons.healing, 'modeKey': 'dermatology'},
    {'label': 'Tick & Flea', 'icon': Icons.bug_report, 'modeKey': 'parasite'},
    {'label': 'Eye Infection', 'icon': Icons.remove_red_eye, 'modeKey': 'ophthalmology'},
    {'label': 'Document OCR', 'icon': Icons.document_scanner, 'modeKey': 'ocr'},
  ];

  final List<Map<String, dynamic>> _scanHistory = [
    {
      'id': 'scan_101',
      'date': 'July 28, 2026',
      'mode': 'Skin Lesion',
      'condition': 'Allergic Dermatitis',
      'confidence': '96.4%',
      'status': 'Mild Risk',
      'recommendations': 'Apply topical soothing balm. Maintain clean fur bedding.',
    },
    {
      'id': 'scan_102',
      'date': 'June 15, 2026',
      'mode': 'Noseprint ID',
      'condition': 'Noseprint Match Confirmed (#9842)',
      'confidence': '99.8%',
      'status': 'Verified',
      'recommendations': 'Pet identity verified in central registry.',
    },
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

  void _triggerDiagnosticScan(String sourceLabel) async {
    setState(() => _isAnalyzing = true);
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isAnalyzing = false);

    final modeLabel = _scanModes[_selectedModeIndex]['label'];
    _showResultsModal(
      context,
      mode: modeLabel,
      condition: modeLabel == 'Noseprint ID' ? 'Identity Verified (Luna #9842)' : 'Epidermal Allergic Dermatitis',
      confidence: '96.8%',
      recommendations: 'Regular cleaning with medicated antiseptic wipes. Monitor area for redness or itching over 48 hours.',
    );
  }

  void _showResultsModal(
    BuildContext context, {
    required String mode,
    required String condition,
    required String confidence,
    required String recommendations,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            AppSpacing.gapLg,
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.primaryTeal, size: 28),
                AppSpacing.gapMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AI Vision Diagnostic Report', style: AppTypography.titleLarge(context)),
                      Text('Scan Mode: $mode • Confidence: $confidence', style: const TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.gapLg,

            // Condition Prediction Card
            GlassContainer(
              padding: AppSpacing.paddingMd,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Predicted Condition:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(condition, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppColors.primaryTeal)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTeal.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Confidence Gauge: 96.8%', style: TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold, fontSize: 11)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryCyan.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Neural Model v2.4', style: TextStyle(color: AppColors.secondaryCyan, fontWeight: FontWeight.bold, fontSize: 11)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.gapMd,

            // Recommendations
            const Text('Actionable Veterinary Recommendations:', style: TextStyle(fontWeight: FontWeight.bold)),
            AppSpacing.gapSm,
            Text(recommendations, style: const TextStyle(color: Colors.grey)),
            AppSpacing.gapLg,

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showCompareModal(context);
                    },
                    icon: const Icon(Icons.compare_arrows, size: 16),
                    label: const Text('Compare Scan'),
                  ),
                ),
                AppSpacing.gapSm,
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal, foregroundColor: Colors.white),
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Report saved to Health Passport!')),
                      );
                    },
                    icon: const Icon(Icons.save, size: 16),
                    label: const Text('Save Report'),
                  ),
                ),
              ],
            ),
            AppSpacing.gapSm,
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('PDF Diagnostic Report generated and downloaded.')),
                      );
                    },
                    icon: const Icon(Icons.picture_as_pdf, size: 16, color: AppColors.primaryTeal),
                    label: const Text('Export PDF', style: TextStyle(color: AppColors.primaryTeal)),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sharing report link...')),
                      );
                    },
                    icon: const Icon(Icons.share, size: 16, color: AppColors.primaryTeal),
                    label: const Text('Share Report', style: TextStyle(color: AppColors.primaryTeal)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCompareModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: AppSpacing.paddingLg,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Compare Scans Side-by-Side', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            AppSpacing.gapMd,
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: AppSpacing.paddingSm,
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
                    child: const Column(
                      children: [
                        Text('Scan (July 28)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        SizedBox(height: 8),
                        Icon(Icons.healing, size: 40, color: AppColors.primaryTeal),
                        SizedBox(height: 8),
                        Text('Severity: Mild', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                ),
                AppSpacing.gapMd,
                Expanded(
                  child: Container(
                    padding: AppSpacing.paddingSm,
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
                    child: const Column(
                      children: [
                        Text('Current Scan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        SizedBox(height: 8),
                        Icon(Icons.check_circle_outline, size: 40, color: Colors.green),
                        SizedBox(height: 8),
                        Text('Severity: Improved', style: TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.gapLg,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal, foregroundColor: Colors.white),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close Comparison'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Vision Diagnostics'),
        actions: [
          IconButton(
            icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: () => setState(() => _isFlashOn = !_isFlashOn),
          ),
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: () => _triggerDiagnosticScan('Gallery Image'),
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: '/pet-owner/ai-scan'),
      body: Column(
        children: [
          // Viewport Container
          Expanded(
            flex: 6,
            child: Container(
              color: Colors.black,
              child: Stack(
                children: [
                  Center(
                    child: _isAnalyzing
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: AppColors.primaryTeal),
                              SizedBox(height: 16),
                              Text('Analyzing Vision Features via Neural Engine...', style: TextStyle(color: Colors.white)),
                            ],
                          )
                        : Container(
                            width: 280,
                            height: 280,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.primaryTeal, width: 3),
                            ),
                            child: Stack(
                              children: [
                                const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.center_focus_weak, size: 64, color: AppColors.primaryTeal),
                                      SizedBox(height: 12),
                                      Text('Align lesion or noseprint inside box', style: TextStyle(color: Colors.white70)),
                                    ],
                                  ),
                                ),
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
                                          color: AppColors.primaryTeal,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.primaryTeal.withOpacity(0.8),
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

                  // Capture Action Floating Controls
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: FloatingActionButton.large(
                        heroTag: 'capture_scan',
                        backgroundColor: AppColors.primaryTeal,
                        onPressed: () => _triggerDiagnosticScan('Camera Image'),
                        child: const Icon(Icons.camera, size: 36, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Scan Mode Carousel & Recent Scans Header
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              padding: AppSpacing.paddingMd,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_scanModes.length, (index) {
                        final isSelected = _selectedModeIndex == index;
                        final mode = _scanModes[index];
                        return GestureDetector(
                          onTap: () => setState(() => _selectedModeIndex = index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryTeal : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(mode['icon'], color: isSelected ? Colors.white : Colors.black87, size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  mode['label'],
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black87,
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
                  AppSpacing.gapMd,
                  Text('Recent Scan History', style: AppTypography.headlineMedium(context)),
                  AppSpacing.gapSm,
                  ..._scanHistory.map((item) {
                    return ListTile(
                      dense: true,
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.primaryTeal,
                        radius: 16,
                        child: Icon(Icons.healing, size: 16, color: Colors.white),
                      ),
                      title: Text(item['condition'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${item['mode']} • ${item['date']} • Confidence: ${item['confidence']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {
                          _showResultsModal(
                            context,
                            mode: item['mode'] as String,
                            condition: item['condition'] as String,
                            confidence: item['confidence'] as String,
                            recommendations: item['recommendations'] as String,
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
