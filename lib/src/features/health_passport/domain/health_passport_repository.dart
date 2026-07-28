import 'medical_record_entity.dart';

abstract class HealthPassportRepository {
  Future<List<MedicalRecordEntity>> getPetRecords(String petId);
  Future<void> addRecord(MedicalRecordEntity record);
}
