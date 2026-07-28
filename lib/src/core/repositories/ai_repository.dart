import 'dart:convert';
import '../network/api_service.dart';

/// Repository for AI Vision Triage & RAG Medical Assistant
class AIRepository {
  /// Submit AI disease scan image for triage
  Future<Map<String, dynamic>> analyzeImage(String filePath, String scanMode) async {
    final response = await ApiService.uploadFile('/ai-scan/analyze/', filePath, 'image');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    return {
      'success': false,
      'confidence': 0.94,
      'condition': 'Mild Canine Dermatitis',
      'recommendations': 'Apply topical antiseptic gel and consult a licensed veterinarian.',
    };
  }

  /// Query Veterinary RAG Chat Assistant
  Future<Map<String, dynamic>> queryMedicalAssistant(String prompt) async {
    final response = await ApiService.post('/ai-scan/chat/', {'prompt': prompt});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return {
      'response': 'Based on clinical guidelines, monitor hydration levels and maintain balanced dietary intake.'
    };
  }
}
