class VitalsData {
  final int heartRateBpm;
  final double bodyTempFahrenheit;
  final int dailySteps;
  final double sleepHours;
  final DateTime lastUpdated;

  const VitalsData({
    required this.heartRateBpm,
    required this.bodyTempFahrenheit,
    required this.dailySteps,
    required this.sleepHours,
    required this.lastUpdated,
  });
}

class PetEntity {
  final String id;
  final String name;
  final String species; // Canine, Feline, etc.
  final String breed;
  final double ageYears;
  final double weightKg;
  final String microchipId;
  final String smartCollarMac;
  final VitalsData vitals;

  const PetEntity({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.ageYears,
    required this.weightKg,
    required this.microchipId,
    required this.smartCollarMac,
    required this.vitals,
  });
}
