import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mock_rescue_repository.dart';
import '../../domain/rescue_incident_entity.dart';
import '../../domain/rescue_repository.dart';

final rescueRepositoryProvider = Provider<RescueRepository>((ref) {
  return MockRescueRepository();
});

final activeIncidentsProvider = FutureProvider<List<RescueIncidentEntity>>((ref) async {
  final repo = ref.watch(rescueRepositoryProvider);
  return repo.getActiveIncidents();
});
