enum ScanMode { noseprint, skinLesion, documentOcr }

class ScanResultEntity {
  final String id;
  final ScanMode mode;
  final String title;
  final double confidenceScore;
  final String diagnosticSummary;
  final List<String> recommendedNextSteps;
  final DateTime scannedAt;

  const ScanResultEntity({
    required this.id,
    required this.mode,
    required this.title,
    required this.confidenceScore,
    required this.diagnosticSummary,
    required this.recommendedNextSteps,
    required this.scannedAt,
  });
}
