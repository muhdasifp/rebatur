import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test/data/local/token.dart';
import 'package:machine_test/feature/auth/provider/auth_state.dart';
import 'package:machine_test/feature/auth/repository/auth_repo.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepoProvider);
  return AuthNotifier(repo);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepo _authRepo;

  AuthNotifier(this._authRepo) : super(AuthInitial());

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      state = AuthLoading();
      await _authRepo.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      state = AuthSuccess();
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      state = AuthLoading();
      final token = await _authRepo.login(email: email, password: password);
      await TokenHelper.saveToken(token);
      state = AuthSuccess();
    } catch (e) {
      state = AuthError(e.toString());
    }
  }
}
