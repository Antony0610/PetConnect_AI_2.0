enum RecordType { vaccine, surgery, dental, labResult, prescription }

class MedicalRecordEntity {
  final String id;
  final String petId;
  final String title;
  final RecordType type;
  final String veterinarianName;
  final String clinicName;
  final DateTime dateAdministered;
  final DateTime? dateExpiration;
  final bool isVerifiedEhr;
  final String? documentFileUrl;

  const MedicalRecordEntity({
    required this.id,
    required this.petId,
    required this.title,
    required this.type,
    required this.veterinarianName,
    required this.clinicName,
    required this.dateAdministered,
    this.dateExpiration,
    this.isVerifiedEhr = true,
    this.documentFileUrl,
  });
}
