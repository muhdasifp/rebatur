import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test/core/http/http_helper.dart';
import 'package:machine_test/data/constant/api.dart';

final authRepoProvider = Provider<AuthRepo>((ref) {
  return AuthRepo(ref.watch(httpHelperProvider));
});

class AuthRepo {
  final HttpHelper _httpHelper;

  AuthRepo(this._httpHelper);

  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _httpHelper.post(
        Api.login,
        body: {"email": email, "password": password},
      );
      return res['token'];
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final res = await _httpHelper.post(
        Api.register,
        body: {
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": passwordConfirmation,
        },
      );
      return res['message'];
    } catch (e) {
      throw e.toString();
    }
  }
}
