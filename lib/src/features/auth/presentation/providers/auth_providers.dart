import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mock_auth_repository.dart';
import '../../domain/auth_repository.dart';
import '../../domain/auth_user.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository();
});

class AuthStateNotifier extends StateNotifier<AsyncValue<AuthUser?>> {
  final AuthRepository _repository;

  AuthStateNotifier(this._repository) : super(const AsyncValue.loading()) {
    checkCurrentUser();
  }

  Future<void> checkCurrentUser() async {
    try {
      final user = await _repository.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.signInWithEmail(email, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AsyncValue.data(null);
  }
}

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AsyncValue<AuthUser?>>((ref) {
  return AuthStateNotifier(ref.watch(authRepositoryProvider));
});
