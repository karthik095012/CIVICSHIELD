import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../providers/preferences_provider.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: '9876543210');
    _passwordController = TextEditingController(text: 'Demo@123');
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    ref.read(authProvider.notifier).login(
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider);
    final authState = ref.watch(authProvider);

    if (authState.isAuthenticated) {
      Future.microtask(() => context.go('/home'));
    }

    final bgColor = isDarkMode ? CivicShieldTheme.darkBg : CivicShieldTheme.surfaceDark;
    final cardColor = isDarkMode ? CivicShieldTheme.darkSurfaceCard : CivicShieldTheme.surfaceCard;
    final textPrimaryColor = isDarkMode ? CivicShieldTheme.darkTextPrimary : CivicShieldTheme.textPrimary;
    final textMutedColor = isDarkMode ? CivicShieldTheme.darkTextMuted : CivicShieldTheme.textMuted;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: CivicShieldTheme.premiumGradient,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset('assets/images/app_logo.png', width: 48, height: 48, fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 20),
                    const Text('CivicShield', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: CivicShieldTheme.primaryDeepTeal)),
                    const SizedBox(height: 8),
                    Text('Know Your Rights • Verify Enforcement', style: TextStyle(fontSize: 13, color: textMutedColor, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Text('Welcome Back', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: textPrimaryColor)),
              const SizedBox(height: 4),
              Text('Sign in to access your civic engagement dashboard', style: TextStyle(fontSize: 14, color: textMutedColor)),
              const SizedBox(height: 28),
              if (authState.error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CivicShieldTheme.dangerRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: CivicShieldTheme.dangerRed, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_rounded, color: CivicShieldTheme.dangerRed, size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text(authState.error!, style: const TextStyle(color: CivicShieldTheme.dangerRed, fontSize: 12))),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text('Phone Number', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimaryColor)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: CivicShieldTheme.borderGlow, width: 1)),
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  enabled: !authState.isLoading,
                  maxLength: 10,
                  style: TextStyle(color: textPrimaryColor, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: '10-digit mobile number',
                    hintStyle: TextStyle(color: textMutedColor),
                    counterText: '',
                    prefixIcon: Icon(Icons.phone_rounded, color: CivicShieldTheme.accentCyan, size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text('Password', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimaryColor)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: CivicShieldTheme.borderGlow, width: 1)),
                child: TextField(
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  enabled: !authState.isLoading,
                  style: TextStyle(color: textPrimaryColor, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(color: textMutedColor),
                    prefixIcon: Icon(Icons.lock_rounded, color: CivicShieldTheme.accentCyan, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(_showPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: CivicShieldTheme.accentCyan, size: 20),
                      onPressed: !authState.isLoading ? () => setState(() => _showPassword = !_showPassword) : null,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: authState.isLoading ? null : _handleLogin,
                  icon: authState.isLoading
                      ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white.withOpacity(0.8))))
                      : const Icon(Icons.login_rounded, size: 18),
                  label: Text(authState.isLoading ? 'Signing in...' : 'Sign In'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CivicShieldTheme.accentCyan,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: CivicShieldTheme.accentCyan.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: TextStyle(fontSize: 13, color: textMutedColor),
                    children: [
                      TextSpan(
                        text: 'Sign up',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: CivicShieldTheme.accentCyan),
                        recognizer: authState.isLoading ? null : (TapGestureRecognizer()..onTap = () => context.push('/signup')),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.blue, width: 1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [Icon(Icons.info_rounded, color: Colors.blue, size: 16), SizedBox(width: 8), Text('Demo Credentials', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700, fontSize: 12))],
                    ),
                    const SizedBox(height: 8),
                    Text('Phone: 9876543210', style: TextStyle(color: textPrimaryColor, fontSize: 12)),
                    Text('Password: Demo@123', style: TextStyle(color: textPrimaryColor, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: CivicShieldTheme.successGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: CivicShieldTheme.successGreen, width: 1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [Icon(Icons.verified_rounded, color: CivicShieldTheme.successGreen, size: 16), SizedBox(width: 8), Text('CivicShield Platform', style: TextStyle(color: CivicShieldTheme.successGreen, fontWeight: FontWeight.w700, fontSize: 12))],
                    ),
                    const SizedBox(height: 8),
                    Text('Report misuse, verify fines, check rights, access schemes—all in one secure platform.', style: TextStyle(color: textMutedColor, fontSize: 11, height: 1.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
