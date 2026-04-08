import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/home/home_dashboard_screen.dart';
import '../screens/fine_checker/fine_checker_screen.dart';
import '../screens/rights/rights_cards_screen.dart';
import '../screens/report/legal_document_analysis_screen.dart';
import '../screens/legal_services/legal_services_map_screen.dart';
import '../screens/evidence_vault/evidence_vault_screen.dart';
import '../screens/evidence_vault/legal_documents_vault_screen.dart';
import '../screens/schemes/schemes_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/authority_directory/authority_directory_screen.dart';
import '../screens/analytics/analytics_dashboard_screen.dart';
import '../screens/legal_consultancy/legal_consultancy_screen.dart';
import '../screens/ai_legal_consultancy/ai_legal_consultancy_screen.dart';
import '../screens/news/legal_news_screen.dart';
import '../app/theme.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeDashboardScreen(),
          ),
          GoRoute(
            path: '/fines',
            builder: (context, state) => const FineCheckerScreen(),
          ),
          GoRoute(
            path: '/rights',
            builder: (context, state) => const RightsCardsScreen(),
          ),
          GoRoute(
            path: '/report',
            builder: (context, state) => const LegalDocumentAnalysisScreen(),
          ),
          GoRoute(
            path: '/hotspot',
            builder: (context, state) => const LegalServicesMapScreen(),
          ),
          GoRoute(
            path: '/vault',
            builder: (context, state) => const EvidenceVaultScreen(),
          ),
          GoRoute(
            path: '/legal-documents',
            builder: (context, state) => const LegalDocumentsVaultScreen(),
          ),
          GoRoute(
            path: '/schemes',
            builder: (context, state) => const SchemesScreen(),
          ),
          GoRoute(
            path: '/authorities',
            builder: (context, state) => const AuthorityDirectoryScreen(),
          ),
          GoRoute(
            path: '/analytics',
            builder: (context, state) => const AnalyticsDashboardScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/legal',
            builder: (context, state) => const LegalConsultancyScreen(),
          ),
          GoRoute(
            path: '/ai-legal',
            builder: (context, state) => const AILegalConsultancyScreen(),
          ),
          GoRoute(
            path: '/news',
            builder: (context, state) => const LegalNewsScreen(),
          ),
        ],
      ),
    ],
  );
}

class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<_NavItem> _navItems = const [
    _NavItem(path: '/home', icon: Icons.home_rounded, label: 'Home'),
    _NavItem(path: '/news', icon: Icons.newspaper_rounded, label: 'News'),
    _NavItem(path: '/rights', icon: Icons.shield_rounded, label: 'Rights'),
    _NavItem(path: '/ai-legal', icon: Icons.smart_toy_rounded, label: 'Legal AI'),
    _NavItem(path: '/hotspot', icon: Icons.location_on_rounded, label: 'Map'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: CivicShieldTheme.borderGlow, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() => _selectedIndex = index);
            context.go(_navItems[index].path);
          },
          items: _navItems.map((item) => BottomNavigationBarItem(
            icon: Icon(item.icon),
            label: item.label,
          )).toList(),
          selectedItemColor: CivicShieldTheme.accentCyan,
          unselectedItemColor: CivicShieldTheme.textMuted,
          backgroundColor: CivicShieldTheme.surfaceCard,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 11,
          unselectedFontSize: 11,
        ),
      ),
    );
  }
}

class _NavItem {
  final String path;
  final IconData icon;
  final String label;
  const _NavItem({required this.path, required this.icon, required this.label});
}
