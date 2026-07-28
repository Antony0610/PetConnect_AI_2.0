import '../domain/admin_repository.dart';
import '../domain/admin_telemetry_entity.dart';

class MockAdminRepository implements AdminRepository {
  @override
  Future<AdminTelemetryEntity> getSystemTelemetry() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const AdminTelemetryEntity(
      totalActiveUsers: 142850,
      smartCollarsOnline: 98420,
      aiScansProcessed24h: 34120,
      systemUptimePercentage: 99.98,
    );
  }
}
