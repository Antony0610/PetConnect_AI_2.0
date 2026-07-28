import '../domain/health_passport_repository.dart';
import '../domain/medical_record_entity.dart';

class MockHealthPassportRepository implements HealthPassportRepository {
  final List<MedicalRecordEntity> _mockRecords = [
    MedicalRecordEntity(
      id: 'rec-101',
      petId: 'pet-001',
      title: 'Rabies 3-Year Vaccine',
      type: RecordType.vaccine,
      veterinarianName: 'Dr. Sarah Jenkins, DVM',
      clinicName: 'Metro Pet Hospital',
      dateAdministered: DateTime(2025, 1, 15),
      dateExpiration: DateTime(2028, 1, 15),
      isVerifiedEhr: true,
    ),
    MedicalRecordEntity(
      id: 'rec-102',
      petId: 'pet-001',
      title: 'DHPP Core Booster',
      type: RecordType.vaccine,
      veterinarianName: 'Dr. Sarah Jenkins, DVM',
      clinicName: 'Metro Pet Hospital',
      dateAdministered: DateTime(2024, 11, 10),
      dateExpiration: DateTime(2025, 11, 10),
      isVerifiedEhr: true,
    ),
    MedicalRecordEntity(
      id: 'rec-103',
      petId: 'pet-001',
      title: 'Routine Dental Scaling & Polish',
      type: RecordType.surgery,
      veterinarianName: 'Dr. Michael Chen',
      clinicName: 'Metro Pet Care Clinic',
      dateAdministered: DateTime(2024, 8, 14),
      isVerifiedEhr: true,
    ),
  ];

  @override
  Future<List<MedicalRecordEntity>> getPetRecords(String petId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockRecords.where((r) => r.petId == petId).toList();
  }

  @override
  Future<void> addRecord(MedicalRecordEntity record) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockRecords.add(record);
  }
}
