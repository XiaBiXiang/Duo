import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import 'appwrite_provider.dart';

class AuthState {
  final models.User? user;
  final bool isLoading;
  final String? error;

  const AuthState({this.user, this.isLoading = false, this.error});

  bool get isAuthenticated => user != null;

  AuthState copyWith({models.User? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _auth;

  AuthNotifier(this._auth) : super(const AuthState(isLoading: true)) {
    _init();
  }

  Future<void> _init() async {
    final user = await _auth.getCurrentUser();
    state = AuthState(user: user);
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _auth.register(email: email, password: password, name: name);
      await _auth.login(email: email, password: password);
      final user = await _auth.getCurrentUser();
      state = AuthState(user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _auth.login(email: email, password: password);
      final user = await _auth.getCurrentUser();
      state = AuthState(user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await _auth.logout();
    } catch (_) {}
    state = const AuthState();
  }

  Future<void> updateName(String name) async {
    try {
      final user = await _auth.updateName(name);
      state = state.copyWith(user: user);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> reauth({required String email, required String password}) async {
    await _auth.reauth(email: email, password: password);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});
