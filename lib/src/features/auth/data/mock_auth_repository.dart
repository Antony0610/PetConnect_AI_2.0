import '../domain/auth_repository.dart';
import '../domain/auth_user.dart';

class MockAuthRepository implements AuthRepository {
  AuthUser? _currentUser = AuthUser(
    uid: 'usr-8841-demo',
    email: 'alex.morgan@petconnect.ai',
    displayName: 'Alex Morgan',
    role: 'pet_owner',
    isBiometricEnabled: true,
    createdAt: DateTime.now().subtract(const Duration(days: 90)),
  );

  @override
  Future<AuthUser?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _currentUser;
  }

  @override
  Future<AuthUser> signInWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _currentUser = AuthUser(
      uid: 'usr-${email.hashCode}',
      email: email,
      displayName: email.split('@').first,
      role: 'pet_owner',
      createdAt: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<AuthUser> registerUser(String email, String password, String displayName, String role) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _currentUser = AuthUser(
      uid: 'usr-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: displayName,
      role: role,
      createdAt: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
  }
}
