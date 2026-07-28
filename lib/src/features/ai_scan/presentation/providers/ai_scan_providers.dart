import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mock_ai_scan_repository.dart';
import '../../domain/ai_scan_repository.dart';

final aiScanRepositoryProvider = Provider<AiScanRepository>((ref) {
  return MockAiScanRepository();
});
