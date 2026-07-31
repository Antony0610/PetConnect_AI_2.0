import 'dart:convert';
import '../network/api_service.dart';

/// Repository for Smart Collar Subsystem & Telemetry
class CollarRepository {
  /// Fetch live collar telemetry data
  Future<Map<String, dynamic>> getCollarTelemetry(String collarId) async {
    final response = await ApiService.get('/collars/devices/$collarId/telemetry/');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return {
      'is_connected': false,
      'battery_level': 0,
      'heart_rate': 0,
      'geofence_status': 'UNPAIRED',
    };
  }

  /// Pair new collar device
  Future<Map<String, dynamic>> pairDevice(String macAddress, String petId) async {
    final response = await ApiService.post('/collars/pair/', {
      'mac_address': macAddress,
      'pet_id': petId,
    });
    return jsonDecode(response.body);
  }
}
