import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/secure_token_storage.dart';

/// Centralized Production HTTP API Client with Automatic JWT Interception
class ApiService {
  static const String baseUrl = 'https://antony06.pythonanywhere.com/api/v1';

  /// GET Request with Automatic Authorization Header
  static Future<http.Response> get(String endpoint) async {
    final token = await SecureTokenStorage.getAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    return await http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);
  }

  /// POST Request with Automatic Authorization Header
  static Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final token = await SecureTokenStorage.getAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    return await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  /// Multipart File Upload for AI Vision Scan & EHR Attachments
  static Future<http.Response> uploadFile(String endpoint, String filePath, String fileFieldName) async {
    final token = await SecureTokenStorage.getAccessToken();
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl$endpoint'));
    
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    
    request.files.add(await http.MultipartFile.fromPath(fileFieldName, filePath));
    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}
