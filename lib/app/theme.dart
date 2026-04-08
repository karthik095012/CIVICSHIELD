import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CivicShieldTheme {
  // ==================== LIGHT THEME COLORS ====================
  // Color Palette - Teal and White Theme
  static const Color primaryDeepTeal = Color(0xFF00796B);
  static const Color primaryMidTeal = Color(0xFF00897B);
  static const Color accentCyan = Color(0xFF00BCD4);
  static const Color accentCyanLight = Color(0xFF4DD0E1);
  static const Color surfaceDark = Color(0xFFFFFFFF);
  static const Color surfaceCard = Color(0xFFF0F8F7);
  static const Color surfaceCardLight = Color(0xFFE0F2F1);
  static const Color borderGlow = Color(0xFFA7DCCB);

  static const Color textPrimary = Color(0xFF00695C);
  static const Color textSecondary = Color(0xFF00897B);
  static const Color textMuted = Color(0xFF80CBC4);
  static const Color textOnAccent = Color(0xFFFFFFFF);

  // ==================== DARK THEME COLORS ====================
  static const Color darkBg = Color(0xFF0D1B2A);
  static const Color darkSurfaceCard = Color(0xFF162A3F);
  static const Color darkSurfaceCardLight = Color(0xFF1E3A52);
  static const Color darkBorderGlow = Color(0xFF00897B);
  static const Color darkTextPrimary = Color(0xFFE0F2F1);
  static const Color darkTextSecondary = Color(0xFF80CBC4);
  static const Color darkTextMuted = Color(0xFF4A7C7E);

  static const Color successGreen = Color(0xFF27AE60);
  static const Color successLight = Color(0xFF2ECC71);
  static const Color warningOrange = Color(0xFFF39C12);
  static const Color dangerRed = Color(0xFFE74C3C);
  static const Color infoBlue = Color(0xFF3498DB);

  static const Color highSeverity = Color(0xFFE74C3C);
  static const Color medSeverity = Color(0xFFF39C12);
  static const Color lowSeverity = Color(0xFF27AE60);

    static ThemeData getTheme({bool isDarkMode = false, bool isHighContrast = false}) {
    // Light theme colors
    final bgColor = isDarkMode
      ? (isHighContrast ? Colors.black : darkBg)
      : (isHighContrast ? Colors.white : surfaceDark);
    final surfaceColor = isDarkMode
      ? (isHighContrast ? const Color(0xFF111111) : darkSurfaceCard)
      : (isHighContrast ? Colors.white : surfaceCard);
    final surfaceColorLight = isDarkMode
      ? (isHighContrast ? const Color(0xFF1C1C1C) : darkSurfaceCardLight)
      : (isHighContrast ? const Color(0xFFF5F5F5) : surfaceCardLight);
    final borderColor = isHighContrast
      ? (isDarkMode ? Colors.white : Colors.black)
      : (isDarkMode ? darkBorderGlow : borderGlow);
    final textPrimary = isDarkMode
      ? (isHighContrast ? Colors.white : darkTextPrimary)
      : (isHighContrast ? Colors.black : textPrimaryLight);
    final textSecondary = isDarkMode
      ? (isHighContrast ? const Color(0xFFE5E5E5) : darkTextSecondary)
      : (isHighContrast ? const Color(0xFF1A1A1A) : textSecondaryLight);
    final textMuted = isDarkMode
      ? (isHighContrast ? const Color(0xFFBFBFBF) : darkTextMuted)
      : (isHighContrast ? const Color(0xFF2D2D2D) : textMutedLight);
    final accentColor = isHighContrast
      ? (isDarkMode ? const Color(0xFFFFD54F) : const Color(0xFF0057D8))
      : accentCyan;

    return ThemeData(
      useMaterial3: true,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: bgColor,
      colorScheme: ColorScheme(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        primary: primaryDeepTeal,
        secondary: accentColor,
        surface: surfaceColor,
        error: dangerRed,
        onPrimary: isDarkMode ? darkTextPrimary : textOnAccent,
        onSecondary: isDarkMode ? darkBg : textOnAccent,
        onSurface: textPrimary,
        onError: Colors.white,
        tertiary: successGreen,
        onTertiary: Colors.white,
      ),
      textTheme: GoogleFonts.nunitoTextTheme(
        TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: -0.5),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: textPrimary),
          displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: textPrimary),
          headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: textPrimary),
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textPrimary),
          headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
          titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary),
          titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textPrimary),
          titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textSecondary),
          bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: textPrimary, height: 1.5),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: textSecondary, height: 1.5),
          bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: textMuted),
          labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary, letterSpacing: 0.5),
          labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textSecondary),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: accentColor,
        unselectedItemColor: textMuted,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderColor, width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColorLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
        hintStyle: TextStyle(color: textMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: isDarkMode ? darkBg : textOnAccent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceColorLight,
        selectedColor: accentColor.withOpacity(0.25),
        side: BorderSide(color: borderColor),
        labelStyle: TextStyle(color: textSecondary, fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerTheme: DividerThemeData(
        color: borderColor,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceColorLight,
        contentTextStyle: TextStyle(color: textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Light theme getters (kept for backward compatibility)
  static const Color textPrimaryLight = Color(0xFF00695C);
  static const Color textSecondaryLight = Color(0xFF00897B);
  static const Color textMutedLight = Color(0xFF80CBC4);

  // ==================== PROFESSIONAL GRADIENTS ====================
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDeepTeal, Color(0xFF00897B)],
  );

  static const LinearGradient premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00796B), Color(0xFF00BCD4), Color(0xFF00897B)],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient saffronGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentCyan, Color(0xFF00897B)],
  );

  static const LinearGradient vibrantSaffronGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF00BCD4), Color(0xFF4DD0E1), Color(0xFF00BCD4)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surfaceCard, surfaceCardLight],
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF5FFFE), Color(0xFFE0F2F1)],
  );

  static const RadialGradient radialGradient = RadialGradient(
    center: Alignment.center,
    radius: 1.5,
    colors: [primaryMidTeal, primaryDeepTeal],
  );

  static LinearGradient severityGradient(String severity) {
    switch (severity) {
      case 'high':
        return const LinearGradient(colors: [Color(0xFFE74C3C), Color(0xFFC0392B)]);
      case 'medium':
        return const LinearGradient(colors: [Color(0xFFF39C12), Color(0xFFD68910)]);
      case 'low':
        return const LinearGradient(colors: [Color(0xFF27AE60), Color(0xFF1E8449)]);
      default:
        return const LinearGradient(colors: [Color(0xFF3498DB), Color(0xFF2980B9)]);
    }
  }

  static Color severityColor(String severity) {
    switch (severity) {
      case 'high':
        return highSeverity;
      case 'medium':
        return medSeverity;
      case 'low':
        return lowSeverity;
      default:
        return infoBlue;
    }
  }

  static Color categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'traffic':
        return const Color(0xFF3498DB);
      case 'anticorruption':
        return const Color(0xFFE74C3C);
      case 'rti':
        return const Color(0xFF9B59B6);
      case 'consumer':
        return const Color(0xFF27AE60);
      case 'women':
        return const Color(0xFFE91E63);
      case 'legal':
        return const Color(0xFFF39C12);
      case 'police':
        return const Color(0xFF2196F3);
      default:
        return primaryMidTeal;
    }
  }

  static IconData categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'helmet':
        return Icons.sports_motorsports;
      case 'seatbelt':
        return Icons.airline_seat_recline_normal;
      case 'mobile':
        return Icons.phone_android;
      case 'drunk_driving':
        return Icons.local_bar;
      case 'signal':
        return Icons.traffic;
      case 'speeding':
        return Icons.speed;
      case 'documents':
        return Icons.description;
      case 'parking':
        return Icons.local_parking;
      case 'emission':
        return Icons.eco;
      case 'number_plate':
        return Icons.featured_play_list;
      case 'lane':
        return Icons.swap_horiz;
      case 'overloading':
        return Icons.local_shipping;
      default:
        return Icons.gavel;
    }
  }

  static Color issueColor(String issueCategory) {
    switch (issueCategory) {
      case 'overcharging':
        return const Color(0xFFE74C3C);
      case 'no_receipt':
        return const Color(0xFFF39C12);
      case 'bribe_request':
        return const Color(0xFF9B59B6);
      case 'pothole':
        return const Color(0xFFE67E22);
      case 'streetlight':
        return const Color(0xFFF1C40F);
      case 'garbage':
        return const Color(0xFF27AE60);
      default:
        return const Color(0xFF3498DB);
    }
  }

  static IconData issueIcon(String issueCategory) {
    switch (issueCategory) {
      case 'overcharging':
        return Icons.money_off;
      case 'no_receipt':
        return Icons.receipt_long;
      case 'bribe_request':
        return Icons.warning_amber;
      case 'pothole':
        return Icons.construction;
      case 'streetlight':
        return Icons.lightbulb_outline;
      case 'garbage':
        return Icons.delete_outline;
      default:
        return Icons.report_problem;
    }
  }
}
