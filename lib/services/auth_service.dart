import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_models.dart';

class AuthService {
  // Replace with your backend URL
  static const String _baseUrl = 'http://localhost:3000/api';
  static const String _localUsersKey = 'local_auth_users';
  
  static final AuthService _instance = AuthService._internal();
  
  factory AuthService() {
    return _instance;
  }
  
  AuthService._internal();

  // Test connection to backend
  Future<bool> isBackendAvailable() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/health'),
      ).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // User signup
  Future<AuthResponse> signup(SignupRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      ).timeout(const Duration(seconds: 30));

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201) {
        return AuthResponse.fromJson(data);
      } else {
        return AuthResponse(
          success: false,
          message: data['message'] ?? 'Signup failed',
        );
      }
    } catch (e) {
      // Backend not reachable -> fallback to local auth mode
      return _localSignup(request);
    }
  }

  // User login
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      ).timeout(const Duration(seconds: 30));

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(data);
      } else {
        return AuthResponse(
          success: false,
          message: data['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      // Backend not reachable -> fallback to local auth mode
      return _localLogin(request);
    }
  }

  // Verify token
  Future<bool> verifyToken(String token) async {
    if (_isLocalToken(token)) {
      final localUser = await _getLocalUserByToken(token);
      return localUser != null;
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/verify'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Get user profile
  Future<AuthResponse> getUserProfile(String token) async {
    if (_isLocalToken(token)) {
      final localUser = await _getLocalUserByToken(token);
      if (localUser == null) {
        return AuthResponse(
          success: false,
          message: 'Local session expired. Please sign in again.',
        );
      }

      return AuthResponse(
        success: true,
        message: 'Profile fetched from local auth',
        user: localUser,
        token: token,
      );
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(data);
      } else {
        return AuthResponse(
          success: false,
          message: data['message'] ?? 'Failed to fetch profile',
        );
      }
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Error: ${e.toString()}',
      );
    }
  }

  // Logout (invalidate token on backend)
  Future<bool> logout(String token) async {
    if (_isLocalToken(token)) {
      return true;
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Request password reset
  Future<AuthResponse> requestPasswordReset(String phone) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/request-reset'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone}),
      ).timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      return AuthResponse(
        success: response.statusCode == 200,
        message: data['message'] ?? 'Request processed',
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Could not reach backend to request password reset.',
      );
    }
  }

  Future<AuthResponse> _localSignup(SignupRequest request) async {
    final users = await _getLocalUsers();

    final duplicatePhone = users.values.any((u) => (u['phone'] as String?) == request.phone);
    final duplicateEmail = users.values.any((u) => (u['email'] as String?) == request.email);

    if (duplicatePhone || duplicateEmail) {
      return AuthResponse(
        success: false,
        message: 'User with this phone or email already exists (local mode).',
      );
    }

    final userId = 'u_${DateTime.now().millisecondsSinceEpoch}';
    final createdAt = DateTime.now().toIso8601String();
    final token = _createLocalToken(userId);

    users[userId] = {
      'id': userId,
      'name': request.name,
      'phone': request.phone,
      'email': request.email,
      'password': request.password,
      'createdAt': createdAt,
    };

    await _saveLocalUsers(users);

    return AuthResponse(
      success: true,
      message: 'Account created in local mode (backend offline).',
      user: User(
        id: userId,
        name: request.name,
        phone: request.phone,
        email: request.email,
        createdAt: createdAt,
      ),
      token: token,
    );
  }

  Future<AuthResponse> _localLogin(LoginRequest request) async {
    final users = await _getLocalUsers();

    Map<String, dynamic>? matched;
    for (final user in users.values) {
      if ((user['phone'] as String?) == request.phone) {
        matched = user;
        break;
      }
    }

    if (matched == null) {
      return AuthResponse(
        success: false,
        message: 'No user found for this phone number in local mode.',
      );
    }

    final savedPassword = matched['password'] as String? ?? '';
    if (savedPassword != request.password) {
      return AuthResponse(
        success: false,
        message: 'Invalid password in local mode.',
      );
    }

    final userId = matched['id'] as String;
    final token = _createLocalToken(userId);

    return AuthResponse(
      success: true,
      message: 'Signed in with local mode (backend offline).',
      user: User(
        id: userId,
        name: matched['name'] as String? ?? 'User',
        phone: matched['phone'] as String? ?? '',
        email: matched['email'] as String? ?? '',
        createdAt: matched['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      ),
      token: token,
    );
  }

  Future<Map<String, dynamic>> _getLocalUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_localUsersKey);
    if (raw == null || raw.isEmpty) {
      return <String, dynamic>{};
    }

    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    return <String, dynamic>{};
  }

  Future<void> _saveLocalUsers(Map<String, dynamic> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localUsersKey, jsonEncode(users));
  }

  bool _isLocalToken(String token) {
    return token.startsWith('local:');
  }

  String _createLocalToken(String userId) {
    return 'local:$userId:${DateTime.now().millisecondsSinceEpoch}';
  }

  String? _userIdFromLocalToken(String token) {
    final parts = token.split(':');
    if (parts.length < 3 || parts.first != 'local') {
      return null;
    }
    return parts[1];
  }

  Future<User?> _getLocalUserByToken(String token) async {
    final userId = _userIdFromLocalToken(token);
    if (userId == null) {
      return null;
    }

    final users = await _getLocalUsers();
    final rawUser = users[userId];
    if (rawUser is! Map<String, dynamic>) {
      return null;
    }

    return User(
      id: rawUser['id'] as String? ?? userId,
      name: rawUser['name'] as String? ?? 'User',
      phone: rawUser['phone'] as String? ?? '',
      email: rawUser['email'] as String? ?? '',
      createdAt: rawUser['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  // Validate phone number format
  static bool isValidPhone(String phone) {
    return phone.length == 10 && int.tryParse(phone) != null;
  }

  // Validate email format
  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  // Validate password
  static String? validatePassword(String password) {
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain lowercase letter';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain uppercase letter';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain a number';
    }
    return null;
  }
}
