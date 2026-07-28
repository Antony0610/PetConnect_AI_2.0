class ClinicalAppointmentEntity {
  final String id;
  final String petName;
  final String ownerName;
  final String reason;
  final DateTime appointmentTime;
  final String status; // 'Checked In', 'AI Flagged', 'Teleconsult', 'Completed'
  final bool isAiFlagged;

  const ClinicalAppointmentEntity({
    required this.id,
    required this.petName,
    required this.ownerName,
    required this.reason,
    required this.appointmentTime,
    required this.status,
    this.isAiFlagged = false,
  });
}
