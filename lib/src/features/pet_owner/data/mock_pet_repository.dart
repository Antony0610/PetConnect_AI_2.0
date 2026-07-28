import '../domain/pet_entity.dart';
import '../domain/pet_repository.dart';

class MockPetRepository implements PetRepository {
  final List<PetEntity> _mockPets = [
    PetEntity(
      id: 'pet-001',
      name: 'Luna',
      species: 'Canine',
      breed: 'Golden Retriever',
      ageYears: 3.2,
      weightKg: 31.5,
      microchipId: '985141002938102',
      smartCollarMac: '71:A2:88:CF',
      vitals: VitalsData(
        heartRateBpm: 78,
        bodyTempFahrenheit: 101.4,
        dailySteps: 8420,
        sleepHours: 9.2,
        lastUpdated: DateTime.now(),
      ),
    ),
  ];

  @override
  Future<List<PetEntity>> getOwnerPets(String ownerUid) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockPets;
  }

  @override
  Future<PetEntity> getPetById(String petId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockPets.firstWhere((p) => p.id == petId, orElse: () => _mockPets.first);
  }

  @override
  Future<void> updatePetVitals(String petId, VitalsData vitals) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
