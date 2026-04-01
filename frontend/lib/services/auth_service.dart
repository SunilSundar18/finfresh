import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // Encrypted storage for JWT tokens
  final _storage = const FlutterSecureStorage();

  // Save the 'access' token from your Django response
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  // Retrieve token to attach to API headers
  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // Clear token on logout
  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }
}