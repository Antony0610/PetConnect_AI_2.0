import 'dart:math';

class GeoPoint {
  final double latitude;
  final double longitude;

  const GeoPoint({required this.latitude, required this.longitude});
}

/// Location & Geofence Distance Service for Smart Collars & Rescue Maps
class LocationService {
  /// Calculates Haversine distance in meters between two coordinates
  static double calculateDistanceMeters(GeoPoint point1, GeoPoint point2) {
    const double earthRadiusMeters = 6371000.0;
    final double dLat = _degreesToRadians(point2.latitude - point1.latitude);
    final double dLon = _degreesToRadians(point2.longitude - point1.longitude);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(point1.latitude)) *
            cos(_degreesToRadians(point2.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusMeters * c;
  }

  static bool isInsideGeofence(GeoPoint petLocation, GeoPoint fenceCenter, double radiusMeters) {
    final distance = calculateDistanceMeters(petLocation, fenceCenter);
    return distance <= radiusMeters;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }
}
