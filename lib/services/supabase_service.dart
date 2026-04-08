import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  late SupabaseClient _client;
  bool _initialized = false;

  factory SupabaseService() {
    return _instance;
  }

  static SupabaseService get instance => _instance;

  SupabaseService._internal();

  SupabaseClient get client => _client;

  // Initialize Supabase with config credentials
  Future<void> initialize() async {
    if (_initialized) return;
    
    if (!SupabaseConfig.isConfigured()) {
      print('⚠️ Supabase not configured. Using local auth fallback.');
      print('Configure Supabase by updating lib/config/supabase_config.dart');
      return;
    }

    try {
      await Supabase.initialize(
        url: SupabaseConfig.url,
        anonKey: SupabaseConfig.anonKey,
      );
      _client = Supabase.instance.client;
      _initialized = true;
      print('✅ Supabase initialized successfully');
    } catch (e) {
      print('❌ Supabase initialization failed: $e');
      print('Falling back to local auth');
    }
  }

  // Get current user
  User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  // Get auth session
  Session? getSession() {
    return _client.auth.currentSession;
  }

  // Check if user is authenticated
  bool isAuthenticated() {
    return _client.auth.currentUser != null;
  }

  // Get access token
  String? getAccessToken() {
    return _client.auth.currentSession?.accessToken;
  }

  // Sign up with email
  Future<AuthResponse> signupWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: metadata ?? {},
    );
  }

  // Sign in with email
  Future<AuthResponse> signinWithEmail({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  // Update user metadata
  Future<User?> updateUserMetadata(Map<String, dynamic> metadata) async {
    final response = await _client.auth.updateUser(
      UserAttributes(data: metadata),
    );
    return response.user;
  }

  // Store user profile
  Future<void> storeUserProfile({
    required String userId,
    required String name,
    required String email,
  }) async {
    await _client.from('user_profiles').upsert({
      'id': userId,
      'name': name,
      'email': email,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final response = await _client
        .from('user_profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    return response;
  }

  // Store incident report
  Future<Map<String, dynamic>> storeIncidentReport({
    required String userId,
    required Map<String, dynamic> reportData,
  }) async {
    return await _client.from('incident_reports').insert({
      'user_id': userId,
      ...reportData,
      'created_at': DateTime.now().toIso8601String(),
    }).select().single();
  }

  // Get incident reports for user
  Future<List<dynamic>> getIncidentReports(String userId) async {
    return await _client
        .from('incident_reports')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
  }

  // Update incident report status
  Future<void> updateReportStatus({
    required String reportId,
    required String status,
  }) async {
    await _client
        .from('incident_reports')
        .update({'status': status})
        .eq('id', reportId);
  }

  // Delete incident report
  Future<void> deleteIncidentReport(String reportId) async {
    await _client.from('incident_reports').delete().eq('id', reportId);
  }

  // Store legal news preference
  Future<void> storeLegalNewsPreference({
    required String userId,
    required bool enabled,
  }) async {
    await _client
        .from('user_preferences')
        .upsert({
          'user_id': userId,
          'legal_news_enabled': enabled,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('user_id', userId);
  }

  // Listen to auth state changes
  Stream<AuthState> authStateChanges() {
    return _client.auth.onAuthStateChange;
  }

  // Test connection
  Future<bool> testConnection() async {
    try {
      await _client.from('user_profiles').select().limit(1);
      return true;
    } catch (_) {
      return false;
    }
  }
}
