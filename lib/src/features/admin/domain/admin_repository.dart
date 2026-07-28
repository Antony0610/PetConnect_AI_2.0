import 'admin_telemetry_entity.dart';

abstract class AdminRepository {
  Future<AdminTelemetryEntity> getSystemTelemetry();
}
