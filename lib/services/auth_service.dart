import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import '../core/constants/app_constants.dart';

/// Authentication service using Appwrite Account API.
class AuthService {
  final Account _account;

  AuthService(Client client) : _account = Account(client);

  Future<models.User> register({
    required String email,
    required String password,
    required String name,
  }) async {
    return await _account.create(
      userId: ID.unique(),
      email: email,
      password: password,
      name: name,
    );
  }

  Future<models.Session> login({
    required String email,
    required String password,
  }) async {
    return await _account.createEmailPasswordSession(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await _account.deleteSession(sessionId: 'current');
  }

  Future<models.User> updateName(String name) async {
    return await _account.updateName(name: name);
  }

  Future<void> reauth({required String email, required String password}) async {
    await _account.createEmailPasswordSession(email: email, password: password);
  }

  Future<models.User?> getCurrentUser() async {
    try {
      return await _account.get();
    } catch (_) {
      return null;
    }
  }
}
