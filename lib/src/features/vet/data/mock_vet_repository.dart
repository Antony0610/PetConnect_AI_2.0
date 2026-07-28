import '../domain/clinical_appointment_entity.dart';
import '../domain/vet_repository.dart';

class MockVetRepository implements VetRepository {
  final List<ClinicalAppointmentEntity> _mockAppointments = [
    ClinicalAppointmentEntity(
      id: 'apt-001',
      petName: 'Luna (Golden Retriever)',
      ownerName: 'Alex Morgan',
      reason: 'Routine Vitals & Dental Scaling Checkup',
      appointmentTime: DateTime.now().add(const Duration(hours: 1)),
      status: 'Checked In',
    ),
    ClinicalAppointmentEntity(
      id: 'apt-002',
      petName: 'Max (German Shepherd)',
      ownerName: 'Rachel Green',
      reason: 'AI Skin Lesion Alert Scan Review',
      appointmentTime: DateTime.now().add(const Duration(hours: 2)),
      status: 'AI Flagged',
      isAiFlagged: true,
    ),
    ClinicalAppointmentEntity(
      id: 'apt-003',
      petName: 'Bella (Persian Cat)',
      ownerName: 'David Miller',
      reason: 'Teleconsultation Follow-up',
      appointmentTime: DateTime.now().add(const Duration(hours: 4)),
      status: 'Teleconsult',
    ),
  ];

  @override
  Future<List<ClinicalAppointmentEntity>> getTodayAppointments(String vetUid) async {
    await Future.delayed(const Duration(milliseconds: 350));
    return _mockAppointments;
  }

  @override
  Future<void> issuePrescription(String petId, String medication, String dosage) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
