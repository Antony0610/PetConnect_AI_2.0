import '../domain/collar_device_entity.dart';
import '../domain/smart_collar_repository.dart';

class MockSmartCollarRepository implements SmartCollarRepository {
  CollarDeviceEntity _device = const CollarDeviceEntity(
    deviceId: 'SC-9821-BLE',
    macAddress: '71:A2:88:CF',
    firmwareVersion: 'v2.4.1',
    batteryPercentage: 94,
    isBleConnected: true,
    isGpsLocked: true,
    satelliteCount: 12,
    currentLatitude: 40.7128,
    currentLongitude: -74.0060,
    geofenceRadiusMeters: 150.0,
    isGeofenceActive: true,
  );

  @override
  Future<CollarDeviceEntity> getCollarStatus(String deviceId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _device;
  }

  @override
  Future<void> updateGeofence(String deviceId, double radiusMeters, bool isActive) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _device = CollarDeviceEntity(
      deviceId: _device.deviceId,
      macAddress: _device.macAddress,
      firmwareVersion: _device.firmwareVersion,
      batteryPercentage: _device.batteryPercentage,
      isBleConnected: _device.isBleConnected,
      isGpsLocked: _device.isGpsLocked,
      satelliteCount: _device.satelliteCount,
      currentLatitude: _device.currentLatitude,
      currentLongitude: _device.currentLongitude,
      geofenceRadiusMeters: radiusMeters,
      isGeofenceActive: isActive,
    );
  }

  @override
  Future<void> triggerFirmwareOta(String deviceId) async {
    await Future.delayed(const Duration(milliseconds: 800));
  }
}
