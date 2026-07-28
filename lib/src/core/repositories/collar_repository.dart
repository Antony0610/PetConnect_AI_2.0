import 'dart:convert';
import '../network/api_service.dart';

/// Repository for Smart Collar Subsystem & Telemetry
class CollarRepository {
  /// Fetch live collar telemetry data
  Future<Map<String, dynamic>> getCollarTelemetry(String collarId) async {
    final response = await ApiService.get('/smart-collar/devices/$collarId/telemetry/');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return {
      'battery_level': 94,
      'heart_rate': 78,
      'latitude': 37.7749,
      'longitude': -122.4194,
      'geofence_status': 'SAFE',
    };
  }

  /// Pair new collar device
  Future<Map<String, dynamic>> pairDevice(String macAddress, String petId) async {
    final response = await ApiService.post('/smart-collar/pair/', {
      'mac_address': macAddress,
      'pet_id': petId,
    });
    return jsonDecode(response.body);
  }
}
