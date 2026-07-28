import 'dart:convert';
import '../network/api_service.dart';

/// Repository for Pet Management & Health Passport Integration
class PetsRepository {
  /// Fetch all pets registered by owner
  Future<List<dynamic>> getMyPets() async {
    final response = await ApiService.get('/pets/');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  /// Create new pet record
  Future<Map<String, dynamic>> createPet(Map<String, dynamic> petData) async {
    final response = await ApiService.post('/pets/', petData);
    return jsonDecode(response.body);
  }

  /// Fetch Health Passport EHR details
  Future<Map<String, dynamic>> getHealthPassport(String petId) async {
    final response = await ApiService.get('/pets/$petId/health-passport/');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return {};
  }
}
