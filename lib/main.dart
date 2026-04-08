import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/theme.dart';
import 'app/router.dart';
import 'providers/preferences_provider.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: CivicShieldTheme.surfaceDark,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // Initialize Supabase with configured credentials
  await SupabaseService.instance.initialize();
  
  runApp(const ProviderScope(child: CivicShieldApp()));
}

class CivicShieldApp extends ConsumerWidget {
  const CivicShieldApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);
    final isSeniorMode = ref.watch(seniorModeProvider);
    final isHighContrast = ref.watch(highContrastProvider);

    return MaterialApp.router(
      title: 'CivicShield',
      theme: CivicShieldTheme.getTheme(
        isDarkMode: isDarkMode,
        isHighContrast: isHighContrast,
      ),
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        final baseScale = mediaQuery.textScaler.scale(1.0);
        final effectiveScale = (isSeniorMode ? baseScale * 1.2 : baseScale).clamp(1.0, 1.8).toDouble();

        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: TextScaler.linear(effectiveScale),
            highContrast: isHighContrast,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
