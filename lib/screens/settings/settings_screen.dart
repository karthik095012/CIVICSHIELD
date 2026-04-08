import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme.dart';
import '../../providers/preferences_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late bool _notifications;
  late String _language;
  late bool _darkMode;

  final _languages = ['English', 'हिंदी (Hindi)', 'ಕನ್ನಡ (Kannada)', 'தமிழ் (Tamil)', 'తెలుగు (Telugu)', 'मराठी (Marathi)'];

  @override
  void initState() {
    super.initState();
    _notifications = true;
    _language = 'English';
    _darkMode = false;
  }

  @override
  Widget build(BuildContext context) {
    _darkMode = ref.watch(themeModeProvider);
    _language = ref.watch(languageProvider);
    final seniorMode = ref.watch(seniorModeProvider);
    final highContrast = ref.watch(highContrastProvider);

    final bgColor = _darkMode
      ? (highContrast ? Colors.black : CivicShieldTheme.darkBg)
      : (highContrast ? Colors.white : CivicShieldTheme.surfaceDark);
    final cardColor = _darkMode
      ? (highContrast ? const Color(0xFF121212) : CivicShieldTheme.darkSurfaceCard)
      : (highContrast ? Colors.white : CivicShieldTheme.surfaceCard);
    final borderColor = highContrast
      ? (_darkMode ? Colors.white : Colors.black)
      : (_darkMode ? CivicShieldTheme.darkBorderGlow : CivicShieldTheme.borderGlow);
    final textPrimaryColor = highContrast
      ? (_darkMode ? Colors.white : Colors.black)
      : (_darkMode ? CivicShieldTheme.darkTextPrimary : CivicShieldTheme.textPrimary);
    final textMutedColor = highContrast
      ? (_darkMode ? const Color(0xFFE0E0E0) : const Color(0xFF303030))
      : (_darkMode ? CivicShieldTheme.darkTextMuted : CivicShieldTheme.textMuted);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(LanguageNotifier.translate('settings', _language), style: TextStyle(color: textPrimaryColor)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: borderColor),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          _buildAppHeader(textPrimaryColor, cardColor, borderColor),
          const SizedBox(height: 24),
          _buildSectionLabel(LanguageNotifier.translate('accessibility', _language), textPrimaryColor: textPrimaryColor),
          _buildToggleTile(
            icon: Icons.elderly_rounded,
            label: LanguageNotifier.translate('senior_mode', _language),
            subtitle: LanguageNotifier.translate('senior_mode_desc', _language),
            value: seniorMode,
            color: const Color(0xFF9B59B6),
            cardColor: cardColor,
            borderColor: borderColor,
            textPrimaryColor: textPrimaryColor,
            textMutedColor: textMutedColor,
            onChanged: (v) => ref.read(seniorModeProvider.notifier).setSeniorMode(v),
          ),
          _buildToggleTile(
            icon: Icons.contrast_rounded,
            label: LanguageNotifier.translate('high_contrast', _language),
            subtitle: LanguageNotifier.translate('high_contrast_desc', _language),
            value: highContrast,
            color: CivicShieldTheme.accentCyan,
            cardColor: cardColor,
            borderColor: borderColor,
            textPrimaryColor: textPrimaryColor,
            textMutedColor: textMutedColor,
            onChanged: (v) => ref.read(highContrastProvider.notifier).setHighContrast(v),
          ),
          const SizedBox(height: 16),
          _buildSectionLabel(LanguageNotifier.translate('display', _language), textPrimaryColor: textPrimaryColor),
          _buildToggleTile(
            icon: Icons.dark_mode_rounded,
            label: LanguageNotifier.translate('dark_mode', _language),
            subtitle: LanguageNotifier.translate('dark_mode_desc', _language),
            value: _darkMode,
            color: Colors.amber,
            cardColor: cardColor,
            borderColor: borderColor,
            textPrimaryColor: textPrimaryColor,
            textMutedColor: textMutedColor,
            onChanged: (v) {
              ref.read(themeModeProvider.notifier).setDarkMode(v);
            },
          ),
          const SizedBox(height: 16),
          _buildSectionLabel(LanguageNotifier.translate('language', _language), textPrimaryColor: textPrimaryColor),
          _buildLanguageSelector(cardColor, borderColor, textPrimaryColor, textMutedColor),
          const SizedBox(height: 16),
          _buildSectionLabel(LanguageNotifier.translate('notifications', _language), textPrimaryColor: textPrimaryColor),
          _buildToggleTile(
            icon: Icons.notifications_rounded,
            label: LanguageNotifier.translate('push_notifications', _language),
            subtitle: LanguageNotifier.translate('push_notifications_desc', _language),
            value: _notifications,
            color: CivicShieldTheme.infoBlue,
            cardColor: cardColor,
            borderColor: borderColor,
            textPrimaryColor: textPrimaryColor,
            textMutedColor: textMutedColor,
            onChanged: (v) => setState(() => _notifications = v),
          ),
          const SizedBox(height: 16),
          _buildSectionLabel(LanguageNotifier.translate('about', _language), textPrimaryColor: textPrimaryColor),
          _buildInfoTile(Icons.info_rounded, LanguageNotifier.translate('app_version', _language), LanguageNotifier.translate('app_version_value', _language), cardColor, borderColor, textPrimaryColor, textMutedColor),
          _buildInfoTile(Icons.gavel_rounded, LanguageNotifier.translate('legal_notice', _language), LanguageNotifier.translate('legal_notice_value', _language), cardColor, borderColor, textPrimaryColor, textMutedColor),
          _buildInfoTile(Icons.privacy_tip_rounded, LanguageNotifier.translate('privacy', _language), LanguageNotifier.translate('privacy_value', _language), cardColor, borderColor, textPrimaryColor, textMutedColor),
          const SizedBox(height: 16),
          _buildSectionLabel(LanguageNotifier.translate('legal_disclaimers', _language), textPrimaryColor: textPrimaryColor),
          _buildDisclaimerBox(cardColor, borderColor, textPrimaryColor, textMutedColor),
          const SizedBox(height: 16),
          _buildSectionLabel(LanguageNotifier.translate('emergency_contacts', _language), textPrimaryColor: textPrimaryColor),
          _buildEmergencyContacts(cardColor, borderColor, textPrimaryColor),
        ],
      ),
    );
  }

  Widget _buildAppHeader(Color textPrimaryColor, Color cardColor, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: CivicShieldTheme.premiumGradient,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: CivicShieldTheme.accentCyan.withOpacity(0.15),
            border: Border.all(color: CivicShieldTheme.accentCyan, width: 2),
          ),
          child: const Icon(Icons.shield_rounded, color: CivicShieldTheme.accentCyan, size: 28),
        ),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(LanguageNotifier.translate('app_name', _language), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black)),
          Text(LanguageNotifier.translate('tagline', _language), style: const TextStyle(fontSize: 12, color: CivicShieldTheme.accentCyan, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(LanguageNotifier.translate('sdg_alignment', _language), style: const TextStyle(fontSize: 10, color: CivicShieldTheme.textMuted)),
        ]),
      ]),
    );
  }

  Widget _buildSectionLabel(String label, {required Color textPrimaryColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label, style: TextStyle(color: CivicShieldTheme.accentCyan, fontWeight: FontWeight.w700, fontSize: 12, letterSpacing: 0.8)),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required String label,
    required String subtitle,
    required bool value,
    required Color color,
    required Color cardColor,
    required Color borderColor,
    required Color textPrimaryColor,
    required Color textMutedColor,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(9)),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textPrimaryColor)),
              Text(subtitle, style: TextStyle(fontSize: 11, color: textMutedColor)),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged, activeColor: color),
      ]),
    );
  }

  Widget _buildLanguageSelector(Color cardColor, Color borderColor, Color textPrimaryColor, Color textMutedColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _language,
          isExpanded: true,
          dropdownColor: cardColor,
          style: TextStyle(color: textPrimaryColor, fontSize: 14, fontWeight: FontWeight.w600),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: textMutedColor),
          items: _languages.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
          onChanged: (v) {
            if (v != null) {
              ref.read(languageProvider.notifier).setLanguage(v);
            }
          },
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value, Color cardColor, Color borderColor, Color textPrimaryColor, Color textMutedColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(children: [
        Icon(icon, color: textMutedColor, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: textMutedColor, fontSize: 11, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(value, style: TextStyle(color: textPrimaryColor, fontSize: 13)),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildDisclaimerBox(Color cardColor, Color borderColor, Color textPrimaryColor, Color textMutedColor) {
    const disclaimers = [
      'Fine amounts are indicative based on latest available official notifications. Always verify with official challan.',
      'This app provides civic awareness and guidance. It is not a substitute for legal advice.',
      'CivicShield does not guarantee government department action on any complaint.',
      "All fee and engagement arrangements with lawyers are direct between user and lawyer.",
    ];
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CivicShieldTheme.warningOrange.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CivicShieldTheme.warningOrange.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning_amber_rounded, size: 15, color: CivicShieldTheme.warningOrange),
              SizedBox(width: 6),
              Text('Mandatory Disclaimers', style: TextStyle(color: CivicShieldTheme.warningOrange, fontWeight: FontWeight.w700, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          ...disclaimers.map((d) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text('• $d', style: TextStyle(color: textMutedColor, fontSize: 11, height: 1.4)),
          )),
        ],
      ),
    );
  }

  Widget _buildEmergencyContacts(Color cardColor, Color borderColor, Color textPrimaryColor) {
    final contacts = [
      ('Police Emergency', '100', Icons.local_police_rounded, CivicShieldTheme.dangerRed),
      ('Women Helpline', '1091', Icons.female_rounded, const Color(0xFFE91E63)),
      ('NALSA Legal Aid', '15100', Icons.gavel_rounded, const Color(0xFF9B59B6)),
      ('Anti-Corruption Bureau', '1064', Icons.no_crash_rounded, CivicShieldTheme.warningOrange),
      ('Consumer Helpline', '1800-11-4000', Icons.shopping_bag_rounded, CivicShieldTheme.successGreen),
    ];
    return Column(
      children: contacts.map((c) {
        final (label, number, icon, color) = c;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(9)),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textPrimaryColor)),
                  Text(number, style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            Icon(Icons.call_rounded, color: color, size: 20),
          ]),
        );
      }).toList(),
    );
  }
}
