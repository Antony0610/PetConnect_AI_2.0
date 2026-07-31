import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/repositories/pets_repository.dart';
import '../../domain/pet_entity.dart';

final petRepositoryProvider = Provider<PetsRepository>((ref) {
  return PetsRepository();
});

final selectedPetProvider = StateProvider<PetEntity?>((ref) {
  return null;
});

final selectedPetIdProvider = Provider<String?>((ref) {
  return ref.watch(selectedPetProvider)?.id;
});
