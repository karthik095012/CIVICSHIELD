import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../models/auth_models.dart' as auth_models;
import 'supabase_service.dart';

class SupabaseAuthService {
  static final SupabaseAuthService _instance = SupabaseAuthService._internal();
  
  factory SupabaseAuthService() {
    return _instance;
  }
  
  SupabaseAuthService._internal();

  final SupabaseService _supabaseService = SupabaseService();

  // Check if Supabase is initialized and available
  Future<bool> isAvailable() async {
    try {
      return await _supabaseService.testConnection();
    } catch (_) {
      return false;
    }
  }

  // Sign up
  Future<auth_models.AuthResponse> signup(auth_models.SignupRequest request) async {
    try {
      final authResponse = await _supabaseService.signupWithEmail(
        email: request.email,
        password: request.password,
        metadata: {
          'full_name': request.name,
          'phone': request.phone,
        },
      );

      if (authResponse.user != null) {
        // Store user profile in database
        await _supabaseService.storeUserProfile(
          userId: authResponse.user!.id,
          name: request.name,
          email: request.email,
        );

        return auth_models.AuthResponse(
          success: true,
          user: auth_models.User(
            id: authResponse.user!.id,
            email: authResponse.user!.email ?? '',
            name: request.name,
            phone: request.phone,
            createdAt: DateTime.now().toIso8601String(),
          ),
          token: authResponse.session?.accessToken ?? '',
          message: 'Signup successful',
        );
      } else {
        return auth_models.AuthResponse(
          success: false,
          message: 'Signup failed. Please try again.',
        );
      }
    } catch (e) {
      return auth_models.AuthResponse(
        success: false,
        message: 'Error: ${e.toString()}',
      );
    }
  }

  // Login
  Future<auth_models.AuthResponse> login(auth_models.LoginRequest request) async {
    try {
      // Use phone as email format for Supabase (phone@civicshield.local)
      final email = '${request.phone}@civicshield.local';
      final authResponse = await _supabaseService.signinWithEmail(
        email: email,
        password: request.password,
      );

      if (authResponse.user != null && authResponse.session != null) {
        // Fetch user profile
        final profile = await _supabaseService.getUserProfile(authResponse.user!.id);
        
        return auth_models.AuthResponse(
          success: true,
          user: auth_models.User(
            id: authResponse.user!.id,
            email: authResponse.user!.email ?? '',
            name: profile?['name'] ?? 'User',
            phone: request.phone,
            createdAt: profile?['created_at'] ?? DateTime.now().toIso8601String(),
          ),
          token: authResponse.session!.accessToken,
          message: 'Login successful',
        );
      } else {
        return auth_models.AuthResponse(
          success: false,
          message: 'Login failed. Invalid credentials.',
        );
      }
    } catch (e) {
      return auth_models.AuthResponse(
        success: false,
        message: 'Error: ${e.toString()}',
      );
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _supabaseService.signOut();
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  // Verify token
  Future<bool> verifyToken(String token) async {
    try {
      final user = _supabaseService.getCurrentUser();
      return user != null && _supabaseService.getAccessToken() == token;
    } catch (_) {
      return false;
    }
  }

  // Get current user
  Future<auth_models.User?> getCurrentUser() async {
    try {
      final user = _supabaseService.getCurrentUser();
      if (user != null) {
        final profile = await _supabaseService.getUserProfile(user.id);
        return auth_models.User(
          id: user.id,
          email: user.email ?? '',
          name: profile?['name'] ?? 'User',
          phone: profile?['phone'] ?? '',
          createdAt: profile?['created_at'] ?? DateTime.now().toIso8601String(),
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _supabaseService.resetPassword(email);
    } catch (e) {
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String userId,
    required String name,
  }) async {
    try {
      await _supabaseService.updateUserMetadata({'full_name': name});
      await _supabaseService.storeUserProfile(
        userId: userId,
        name: name,
        email: _supabaseService.getCurrentUser()?.email ?? '',
      );
    } catch (e) {
      throw Exception('Profile update failed: ${e.toString()}');
    }
  }
}
