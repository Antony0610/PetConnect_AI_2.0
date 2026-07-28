import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/services/secure_token_storage.dart';

/// Production Authentication Repository integrating with PetConnect DRF Backend
class AuthRepository {
  // Live Backend Base URL (Configurable via Environment)
  static const String baseUrl = 'https://antony06.pythonanywhere.com/api/v1/auth';

  /// Authenticate User & Store JWT Tokens
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final accessToken = data['access'] ?? data['data']?['access'] ?? 'jwt_access_token_demo';
      final refreshToken = data['refresh'] ?? data['data']?['refresh'] ?? 'jwt_refresh_token_demo';
      final role = data['user']?['role'] ?? data['role'] ?? 'pet_owner';
      final userId = data['user']?['id']?.toString() ?? 'user_1';

      await SecureTokenStorage.saveSession(
        accessToken: accessToken,
        refreshToken: refreshToken,
        role: role,
        email: email,
        userId: userId,
      );

      return {'success': true, 'role': role, 'data': data};
    } else {
      return {
        'success': false,
        'error': jsonDecode(response.body)['detail'] ?? 'Invalid credentials or inactive account.',
      };
    }
  }

  /// Register New User Account
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'password': password,
        'role': role,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      return {
        'success': false,
        'error': jsonDecode(response.body)['detail'] ?? 'Registration failed. Email or phone may already exist.',
      };
    }
  }

  /// Send Forgot Password Reset OTP
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/forgot-password/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'message': 'Password reset OTP sent to $email'};
    } else {
      return {'success': false, 'error': 'Account not found with provided email'};
    }
  }

  /// Verify Email/Phone OTP
  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-otp/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'message': 'Verification successful'};
    } else {
      return {'success': false, 'error': 'Invalid or expired OTP'};
    }
  }

  /// Logout & Clear Local Session
  Future<void> logout() async {
    await SecureTokenStorage.clearSession();
  }
}
