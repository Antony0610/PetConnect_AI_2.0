import 'package:flutter_riverpod/flutter_riverpod.dart';

final clinicalAppointmentsProvider = StateProvider<List<Map<String, dynamic>>>((ref) {
  return [];
});
