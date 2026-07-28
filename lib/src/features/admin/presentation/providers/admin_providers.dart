import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mock_admin_repository.dart';
import '../../domain/admin_repository.dart';
import '../../domain/admin_telemetry_entity.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return MockAdminRepository();
});

final systemTelemetryProvider = FutureProvider<AdminTelemetryEntity>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  return repo.getSystemTelemetry();
});
