import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/network/api_client.dart';
import '../../core/utils/jwt_helper.dart';
import '../models/user_model.dart';

class AuthService {
  final _api = ApiClient().dio;
  final _storage = const FlutterSecureStorage();

  Future<String> login(String email, String password) async {
    final response = await _api.post('/auth/login', data: {
      'email': email,
      'motDePasse': password,
    });
    final token = response.data['token'] as String;
    await _storage.write(key: 'jwt_token', value: token);

    final role = JwtHelper.getRole(token) ?? 'CLIENT';
    await _storage.write(key: 'user_role', value: role);

    return role;
  }

  Future<void> register(UserModel user) async {
    await _api.post('/auth/register', data: user.toJson());
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }

  Future<String?> getRole() => _storage.read(key: 'user_role');
  Future<String?> getToken() => _storage.read(key: 'jwt_token');
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'jwt_token');
    return token != null;
  }
}