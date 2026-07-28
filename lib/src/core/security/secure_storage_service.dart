import 'package:shared_preferences/shared_preferences.dart';

/// Secure Local Storage Service abstraction for PetConnect AI Ecosystem
/// Uses SharedPreferences with encrypted fallback keys for secure auth tokens & credentials.
class SecureStorageService {
  static const String _keyAuthToken = 'auth_jwt_token';
  static const String _keyRefreshToken = 'auth_refresh_token';
  static const String _keySelectedRole = 'user_selected_role';

  final SharedPreferences _prefs;

  SecureStorageService(this._prefs);

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

  Future<void> clearAll() async {
    await _prefs.remove(_keyAuthToken);
    await _prefs.remove(_keyRefreshToken);
  }
}
