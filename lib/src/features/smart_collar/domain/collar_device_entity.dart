class CollarDeviceEntity {
  final String deviceId;
  final String macAddress;
  final String firmwareVersion;
  final int batteryPercentage;
  final bool isBleConnected;
  final bool isGpsLocked;
  final int satelliteCount;
  final double currentLatitude;
  final double currentLongitude;
  final double geofenceRadiusMeters;
  final bool isGeofenceActive;

  const CollarDeviceEntity({
    required this.deviceId,
    required this.macAddress,
    required this.firmwareVersion,
    required this.batteryPercentage,
    required this.isBleConnected,
    required this.isGpsLocked,
    required this.satelliteCount,
    required this.currentLatitude,
    required this.currentLongitude,
    required this.geofenceRadiusMeters,
    required this.isGeofenceActive,
  });
}
