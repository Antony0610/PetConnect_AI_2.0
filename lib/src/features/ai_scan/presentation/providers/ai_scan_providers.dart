import 'package:flutter_riverpod/flutter_riverpod.dart';

final aiScanHistoryProvider = StateProvider<List<Map<String, dynamic>>>((ref) {
  return [];
});
