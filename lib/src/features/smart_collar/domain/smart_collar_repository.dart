import 'collar_device_entity.dart';

abstract class SmartCollarRepository {
  Future<CollarDeviceEntity> getCollarStatus(String deviceId);
  Future<void> updateGeofence(String deviceId, double radiusMeters, bool isActive);
  Future<void> triggerFirmwareOta(String deviceId);
}
