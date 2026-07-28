import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mock_pet_repository.dart';
import '../../domain/pet_entity.dart';
import '../../domain/pet_repository.dart';

final petRepositoryProvider = Provider<PetRepository>((ref) {
  return MockPetRepository();
});

final ownerPetsProvider = FutureProvider.family<List<PetEntity>, String>((ref, ownerUid) async {
  final repo = ref.watch(petRepositoryProvider);
  return repo.getOwnerPets(ownerUid);
});
