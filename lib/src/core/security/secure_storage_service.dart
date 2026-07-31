import 'package:shared_preferences/shared_preferences.dart';

/// Secure Storage Service abstraction for PetConnect AI Ecosystem.
/// Stores JWT Tokens, Refresh Tokens, Active User Role, Profile Metadata, and Onboarding state.
class SecureStorageService {
  static const String _keyAuthToken = 'auth_jwt_token';
  static const String _keyRefreshToken = 'auth_refresh_token';
  static const String _keySelectedRole = 'user_selected_role';
  static const String _keyUserUid = 'user_uid';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserName = 'user_name';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyHasSeenOnboarding = 'has_seen_onboarding';

  final SharedPreferences _prefs;

  SecureStorageService(this._prefs);

  static Future<SecureStorageService> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return SecureStorageService(prefs);
  }

  Future<void> saveAuthToken(String token) async {
    await _prefs.setString(_keyAuthToken, token);
  }

  String? getAuthToken() {
    return _prefs.getString(_keyAuthToken);
  }

  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString(_keyRefreshToken, token);
  }

  String? getRefreshToken() {
    return _prefs.getString(_keyRefreshToken);
  }

  Future<void> saveSelectedRole(String role) async {
    await _prefs.setString(_keySelectedRole, role);
  }

  String getSelectedRole() {
    return _prefs.getString(_keySelectedRole) ?? 'pet_owner';
  }

  Future<void> saveUserData({
    required String uid,
    required String email,
    required String name,
    required String role,
    String? phone,
  }) async {
    await _prefs.setString(_keyUserUid, uid);
    await _prefs.setString(_keyUserEmail, email);
    await _prefs.setString(_keyUserName, name);
    await _prefs.setString(_keySelectedRole, role);
    if (phone != null) {
      await _prefs.setString(_keyUserPhone, phone);
    }
  }

  Map<String, String?> getUserData() {
    return {
      'uid': _prefs.getString(_keyUserUid),
      'email': _prefs.getString(_keyUserEmail),
      'name': _prefs.getString(_keyUserName),
      'role': _prefs.getString(_keySelectedRole),
      'phone': _prefs.getString(_keyUserPhone),
    };
  }

  Future<void> setHasSeenOnboarding(bool value) async {
    await _prefs.setBool(_keyHasSeenOnboarding, value);
  }

  bool getHasSeenOnboarding() {
    return _prefs.getBool(_keyHasSeenOnboarding) ?? false;
  }

  Future<void> clearAll() async {
    await _prefs.remove(_keyAuthToken);
    await _prefs.remove(_keyRefreshToken);
    await _prefs.remove(_keyUserUid);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyUserName);
    await _prefs.remove(_keyUserPhone);
    await _prefs.remove(_keySelectedRole);
  }
}
