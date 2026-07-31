import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/repositories/pets_repository.dart';

final petRepositoryProvider = Provider<PetsRepository>((ref) {
  return PetsRepository();
});
