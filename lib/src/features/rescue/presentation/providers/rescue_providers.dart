import 'package:flutter_riverpod/flutter_riverpod.dart';

final rescueAlertsProvider = StateProvider<List<Map<String, dynamic>>>((ref) {
  return [];
});
