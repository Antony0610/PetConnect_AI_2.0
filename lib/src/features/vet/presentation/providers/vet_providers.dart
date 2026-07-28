import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mock_vet_repository.dart';
import '../../domain/clinical_appointment_entity.dart';
import '../../domain/vet_repository.dart';

final vetRepositoryProvider = Provider<VetRepository>((ref) {
  return MockVetRepository();
});

final vetAppointmentsProvider = FutureProvider.family<List<ClinicalAppointmentEntity>, String>((ref, vetUid) async {
  final repo = ref.watch(vetRepositoryProvider);
  return repo.getTodayAppointments(vetUid);
});
