import 'dart:convert';
import '../network/api_service.dart';

/// Repository for Rescue Subsystem & Emergency Lost Pet SOS Reports
class RescueRepository {
  /// Report emergency lost pet report / SOS
  Future<Map<String, dynamic>> triggerEmergencySOS(Map<String, dynamic> sosPayload) async {
    final response = await ApiService.post('/rescue/emergency-sos/', sosPayload);
    return jsonDecode(response.body);
  }

  /// Fetch active rescue missions for volunteers
  Future<List<dynamic>> getActiveMissions() async {
    final response = await ApiService.get('/rescue/missions/');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }
}
