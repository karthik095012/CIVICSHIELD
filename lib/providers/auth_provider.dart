import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_models.dart';
import '../services/auth_service.dart';

// Auth state notifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final User? user;
  final String? token;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.user,
    this.token,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  factory AuthState.initial() {
    return AuthState(
      user: null,
      token: null,
      isLoading: false,
      error: null,
      isAuthenticated: false,
    );
  }

  AuthState copyWith({
    User? user,
    String? token,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final _authService = AuthService();
  late SharedPreferences _prefs;
  bool _prefsReady = false;

  AuthNotifier() : super(AuthState.initial()) {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    _prefs = await SharedPreferences.getInstance();
    _prefsReady = true;
    final token = _prefs.getString('auth_token');
    if (token != null && token.isNotEmpty) {
      await _restoreSession(token);
    }
  }

  Future<void> _ensurePrefsInitialized() async {
    if (_prefsReady) {
      return;
    }
    await _initializeAuth();
  }

  Future<void> _restoreSession(String token) async {
    final isValid = await _authService.verifyToken(token);
    if (isValid) {
      final response = await _authService.getUserProfile(token);
      if (response.success && response.user != null) {
        state = state.copyWith(
          user: response.user,
          token: token,
          isAuthenticated: true,
          error: null,
        );
      } else {
        await _clearAuth();
      }
    } else {
      await _clearAuth();
    }
  }

  Future<void> signup({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    await _ensurePrefsInitialized();
    state = state.copyWith(isLoading: true, error: null);

    if (name.isEmpty) {
      state = state.copyWith(isLoading: false, error: 'Name is required');
      return;
    }

    if (!AuthService.isValidPhone(phone)) {
      state = state.copyWith(isLoading: false, error: 'Please enter a valid 10-digit phone number');
      return;
    }

    if (!AuthService.isValidEmail(email)) {
      state = state.copyWith(isLoading: false, error: 'Please enter a valid email address');
      return;
    }

    final passwordError = AuthService.validatePassword(password);
    if (passwordError != null) {
      state = state.copyWith(isLoading: false, error: passwordError);
      return;
    }

    final request = SignupRequest(name: name, phone: phone, email: email, password: password);

    try {
      final response = await _authService.signup(request);

      if (response.success && response.user != null && response.token != null) {
        await _prefs.setString('auth_token', response.token!);
        await _prefs.setString('user_id', response.user!.id);
        await _prefs.setString('user_phone', response.user!.phone);

        state = state.copyWith(
          user: response.user,
          token: response.token,
          isAuthenticated: true,
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(isLoading: false, error: response.message);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Signup failed: ${e.toString()}');
    }
  }

  Future<void> login({
    required String phone,
    required String password,
  }) async {
    await _ensurePrefsInitialized();
    state = state.copyWith(isLoading: true, error: null);

    if (!AuthService.isValidPhone(phone)) {
      state = state.copyWith(isLoading: false, error: 'Please enter a valid 10-digit phone number');
      return;
    }

    if (password.isEmpty) {
      state = state.copyWith(isLoading: false, error: 'Password is required');
      return;
    }

    final request = LoginRequest(phone: phone, password: password);

    try {
      final response = await _authService.login(request);

      if (response.success && response.user != null && response.token != null) {
        await _prefs.setString('auth_token', response.token!);
        await _prefs.setString('user_id', response.user!.id);
        await _prefs.setString('user_phone', response.user!.phone);

        state = state.copyWith(
          user: response.user,
          token: response.token,
          isAuthenticated: true,
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(isLoading: false, error: response.message);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Login failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    await _ensurePrefsInitialized();
    state = state.copyWith(isLoading: true);

    if (state.token != null) {
      try {
        await _authService.logout(state.token!);
      } catch (e) {
        // Continue with logout even if backend call fails
      }
    }

    await _clearAuth();
  }

  Future<void> _clearAuth() async {
    await _ensurePrefsInitialized();
    await _prefs.remove('auth_token');
    await _prefs.remove('user_id');
    await _prefs.remove('user_phone');

    state = AuthState.initial();
  }

  Future<void> clearError() async {
    state = state.copyWith(error: null);
  }
}
