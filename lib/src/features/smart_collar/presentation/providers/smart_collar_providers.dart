import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mock_smart_collar_repository.dart';
import '../../domain/collar_device_entity.dart';
import '../../domain/smart_collar_repository.dart';

final smartCollarRepositoryProvider = Provider<SmartCollarRepository>((ref) {
  return MockSmartCollarRepository();
});

final collarStatusProvider = FutureProvider.family<CollarDeviceEntity, String>((ref, deviceId) async {
  final repo = ref.watch(smartCollarRepositoryProvider);
  return repo.getCollarStatus(deviceId);
});
