import 'pet_entity.dart';

abstract class PetRepository {
  Future<List<PetEntity>> getOwnerPets(String ownerUid);
  Future<PetEntity> getPetById(String petId);
  Future<void> updatePetVitals(String petId, CollarTelemetry vitals);
}
