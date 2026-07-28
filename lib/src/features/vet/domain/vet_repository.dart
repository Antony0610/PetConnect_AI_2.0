import 'clinical_appointment_entity.dart';

abstract class VetRepository {
  Future<List<ClinicalAppointmentEntity>> getTodayAppointments(String vetUid);
  Future<void> issuePrescription(String petId, String medication, String dosage);
}
