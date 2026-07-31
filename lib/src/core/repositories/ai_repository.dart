import 'dart:convert';
import '../network/api_service.dart';

/// Repository for AI Vision Triage & RAG Medical Assistant
class AIRepository {
  /// Submit AI disease scan image for triage
  Future<Map<String, dynamic>> analyzeImage(String filePath, String scanMode) async {
    final response = await ApiService.uploadFile('/ai/analyze/', filePath, 'image');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    return {
      'success': false,
      'message': 'Failed to process AI vision scan.',
      'confidence': 0.0,
      'condition': 'Scan Processing Error',
      'recommendations': 'Retry scan or consult a licensed veterinarian.',
    };
  }

  /// Query Veterinary RAG Chat Assistant
  Future<Map<String, dynamic>> queryMedicalAssistant(String prompt) async {
    final response = await ApiService.post('/ai/assistant/chat/', {'prompt': prompt});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return {
      'response': 'Unable to connect to AI Assistant service. Verify internet connectivity.'
    };
  }

  /// Alias for queryMedicalAssistant
  Future<Map<String, dynamic>> askAssistant(String prompt) => queryMedicalAssistant(prompt);
}
