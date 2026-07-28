import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mock_health_passport_repository.dart';
import '../../domain/health_passport_repository.dart';
import '../../domain/medical_record_entity.dart';

final healthPassportRepositoryProvider = Provider<HealthPassportRepository>((ref) {
  return MockHealthPassportRepository();
});

final petMedicalRecordsProvider = FutureProvider.family<List<MedicalRecordEntity>, String>((ref, petId) async {
  final repo = ref.watch(healthPassportRepositoryProvider);
  return repo.getPetRecords(petId);
});
