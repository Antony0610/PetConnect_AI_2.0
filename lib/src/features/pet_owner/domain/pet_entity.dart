class CollarTelemetry {
  final int dailySteps;
  final double sleepHours;
  final int activeMinutes;
  final int batteryLevel;
  final String gpsStatus;
  final DateTime lastUpdated;

  const CollarTelemetry({
    required this.dailySteps,
    required this.sleepHours,
    required this.activeMinutes,
    required this.batteryLevel,
    required this.gpsStatus,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() => {
        'dailySteps': dailySteps,
        'sleepHours': sleepHours,
        'activeMinutes': activeMinutes,
        'batteryLevel': batteryLevel,
        'gpsStatus': gpsStatus,
        'lastUpdated': lastUpdated.toIso8601String(),
      };

  factory CollarTelemetry.fromJson(Map<String, dynamic> json) => CollarTelemetry(
        dailySteps: json['dailySteps'] ?? 8420,
        sleepHours: (json['sleepHours'] as num?)?.toDouble() ?? 9.2,
        activeMinutes: json['activeMinutes'] ?? 145,
        batteryLevel: json['batteryLevel'] ?? 94,
        gpsStatus: json['gpsStatus'] ?? 'Locked (High Accuracy)',
        lastUpdated: json['lastUpdated'] != null ? DateTime.parse(json['lastUpdated']) : DateTime.now(),
      );
}

class PetEntity {
  final String id;
  final String name;
  final String species;
  final String breed;
  final double ageYears;
  final String gender;
  final double weightKg;
  final String color;
  final String vaccinationStatus;
  final String medicalNotes;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final String ownerName;
  final String photoUrl;
  final List<String> galleryPhotos;
  final CollarTelemetry vitals;

  const PetEntity({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.ageYears,
    this.gender = 'Male',
    required this.weightKg,
    this.color = 'Golden',
    this.vaccinationStatus = 'Up-to-Date',
    this.medicalNotes = 'Healthy, regular checkups complete.',
    this.emergencyContactName = 'Dr. Sarah Jenkins',
    this.emergencyContactPhone = '+1 (800) 555-PETS',
    this.ownerName = 'Pet Owner',
    this.photoUrl = '',
    this.galleryPhotos = const [],
    required this.vitals,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'species': species,
        'breed': breed,
        'ageYears': ageYears,
        'gender': gender,
        'weightKg': weightKg,
        'color': color,
        'vaccinationStatus': vaccinationStatus,
        'medicalNotes': medicalNotes,
        'emergencyContactName': emergencyContactName,
        'emergencyContactPhone': emergencyContactPhone,
        'ownerName': ownerName,
        'photoUrl': photoUrl,
        'galleryPhotos': galleryPhotos,
        'vitals': vitals.toJson(),
      };

  factory PetEntity.fromJson(Map<String, dynamic> json) => PetEntity(
        id: json['id'] ?? 'pet_${DateTime.now().millisecondsSinceEpoch}',
        name: json['name'] ?? 'Luna',
        species: json['species'] ?? 'Dog',
        breed: json['breed'] ?? 'Golden Retriever',
        ageYears: (json['ageYears'] as num?)?.toDouble() ?? 3.5,
        gender: json['gender'] ?? 'Female',
        weightKg: (json['weightKg'] as num?)?.toDouble() ?? 28.5,
        color: json['color'] ?? 'Golden',
        vaccinationStatus: json['vaccinationStatus'] ?? 'Up-to-Date',
        medicalNotes: json['medicalNotes'] ?? 'Healthy, regular checkups complete.',
        emergencyContactName: json['emergencyContactName'] ?? 'Dr. Sarah Jenkins',
        emergencyContactPhone: json['emergencyContactPhone'] ?? '+1 (800) 555-PETS',
        ownerName: json['ownerName'] ?? 'Pet Owner',
        photoUrl: json['photoUrl'] ?? '',
        galleryPhotos: List<String>.from(json['galleryPhotos'] ?? []),
        vitals: json['vitals'] != null
            ? CollarTelemetry.fromJson(json['vitals'])
            : CollarTelemetry(
                dailySteps: 8420,
                sleepHours: 9.2,
                activeMinutes: 145,
                batteryLevel: 94,
                gpsStatus: 'Locked (High Accuracy)',
                lastUpdated: DateTime.now(),
              ),
      );
}
