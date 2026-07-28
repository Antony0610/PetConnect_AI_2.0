import 'auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser?> getCurrentUser();
  Future<AuthUser> signInWithEmail(String email, String password);
  Future<AuthUser> registerUser(String email, String password, String displayName, String role);
  Future<void> signOut();
}
