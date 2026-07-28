import '../domain/ai_scan_repository.dart';
import '../domain/scan_result_entity.dart';

class MockAiScanRepository implements AiScanRepository {
  @override
  Future<ScanResultEntity> processImageScan(String imagePath, ScanMode mode) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    switch (mode) {
      case ScanMode.noseprint:
        return ScanResultEntity(
          id: 'scan-${DateTime.now().millisecondsSinceEpoch}',
          mode: ScanMode.noseprint,
          title: 'Noseprint Verified: Luna',
          confidenceScore: 0.988,
          diagnosticSummary: 'Matched against registered canine biometric database (Microchip 985141002938102).',
          recommendedNextSteps: ['Biometric record verified', 'Identity confirmed in registry'],
          scannedAt: DateTime.now(),
        );
      case ScanMode.skinLesion:
        return ScanResultEntity(
          id: 'scan-${DateTime.now().millisecondsSinceEpoch}',
          mode: ScanMode.skinLesion,
          title: 'Benign Allergic Dermatitis',
          confidenceScore: 0.924,
          diagnosticSummary: 'Localized epidermal erythema detected. Low probability of fungal infection.',
          recommendedNextSteps: ['Apply topical antiseptic ointment', 'Schedule vet review if spreading'],
          scannedAt: DateTime.now(),
        );
      case ScanMode.documentOcr:
        return ScanResultEntity(
          id: 'scan-${DateTime.now().millisecondsSinceEpoch}',
          mode: ScanMode.documentOcr,
          title: 'Medical Records OCR Processed',
          confidenceScore: 0.965,
          diagnosticSummary: 'Extracted 3 core vaccines and dental procedure dates automatically.',
          recommendedNextSteps: ['Review parsed entries', 'Save to Pet Health Passport'],
          scannedAt: DateTime.now(),
        );
    }
  }
}
