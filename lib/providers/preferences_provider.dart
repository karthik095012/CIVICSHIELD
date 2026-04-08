import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Theme Mode Provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, bool>((ref) {
  return ThemeModeNotifier();
});

// Senior Mode Provider
final seniorModeProvider = StateNotifierProvider<SeniorModeNotifier, bool>((ref) {
  return SeniorModeNotifier();
});

// High Contrast Provider
final highContrastProvider = StateNotifierProvider<HighContrastNotifier, bool>((ref) {
  return HighContrastNotifier();
});

class ThemeModeNotifier extends StateNotifier<bool> {
  ThemeModeNotifier() : super(false) {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('isDarkMode') ?? false;
  }

  Future<void> setDarkMode(bool isDark) async {
    state = isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }
}

class SeniorModeNotifier extends StateNotifier<bool> {
  SeniorModeNotifier() : super(false) {
    _loadSeniorMode();
  }

  Future<void> _loadSeniorMode() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('isSeniorMode') ?? false;
  }

  Future<void> setSeniorMode(bool enabled) async {
    state = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSeniorMode', enabled);
  }
}

class HighContrastNotifier extends StateNotifier<bool> {
  HighContrastNotifier() : super(false) {
    _loadHighContrast();
  }

  Future<void> _loadHighContrast() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('isHighContrast') ?? false;
  }

  Future<void> setHighContrast(bool enabled) async {
    state = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isHighContrast', enabled);
  }
}

// Language Provider
final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super('English') {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('language') ?? 'English';
  }

  Future<void> setLanguage(String language) async {
    state = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }

  static const Map<String, Map<String, String>> translations = {
    'English': {
      'settings': 'Settings',
      'accessibility': 'Accessibility',
      'senior_mode': 'Senior Mode',
      'senior_mode_desc': 'Larger text, simpler navigation',
      'high_contrast': 'High Contrast',
      'high_contrast_desc': 'Enhanced visibility for low vision',
      'language': 'Language',
      'notifications': 'Notifications',
      'push_notifications': 'Push Notifications',
      'push_notifications_desc': 'Scheme alerts, escalation reminders',
      'about': 'About',
      'app_version': 'App Version',
      'app_version_value': 'CivicShield v1.0 — Hackathon MVP',
      'legal_notice': 'Legal Notice',
      'legal_notice_value': 'Fine amounts are indicative only',
      'privacy': 'Privacy',
      'privacy_value': 'Anonymous-first. Data stored locally.',
      'legal_disclaimers': 'Legal Disclaimers',
      'emergency_contacts': 'Emergency Contacts',
      'dark_mode': 'Dark Mode',
      'dark_mode_desc': 'Easy on the eyes in low light',
      'civil_shield': 'CivicShield',
      'app_name': 'CivicShield',
      'tagline': 'Know. Verify. Strengthen.',
      'sdg_alignment': 'SDG 9 + SDG 16 Aligned',
      'display': 'Display',
      'home': 'Home',
      'fines': 'Fine Checker',
      'rights': 'Rights & Laws',
      'report': 'Report Misuse',
      'hotspot': 'Community Hotspot',
      'vault': 'Evidence Vault',
      'know_your_rights': 'Know Your Rights • Verify Enforcement',
      'quick_actions': 'Quick Actions',
      'more_tools': 'More Tools',
      'quick_tip': 'Daily Civic Tip',
      'challan_tip': 'Always request an official challan before paying any traffic fine.',
      'complaint_notice': '1 complaint needs attention',
      'escalate_time': '7 days without resolution — escalate now',
      'escalate_btn': 'Escalate',
      'fine_checker': 'Fine\nChecker',
      'fine_checker_sub': '25+ violations',
      'know_rights': 'Know Your\nRights',
      'know_rights_sub': '8 scenarios',
      'report_misuse': 'File\nCase',
      'report_misuse_sub': 'Legal document analysis',
      'community_map': 'Community\nMap',
      'community_map_sub': '10 hotspots',
      'evidence': 'Evidence\nVault',
      'evidence_sub': 'Store & secure',
      'schemes': 'Govt\nSchemes',
      'schemes_sub': 'Benefits info',
      'traffic_fines': 'Traffic Fines',
      'parking_fines': 'Parking Fines',
      'regulatory_fines': 'Regulatory Fines',
      'report_submitted': 'Report Submitted!',
      'ai_report': 'AI Generated Report',
      'submit_report': 'Submit Report',
      'legal': 'Legal\nConsultancy',
      'legal_sub': 'Expert advice',
      'ai_legal': 'AI Legal\nAdvisor',
      'ai_legal_sub': '🆓 Free',
      'close': 'Close',
    },
    'हिंदी (Hindi)': {
      'settings': 'सेटिंग्स',
      'accessibility': 'पहुँच-योग्यता',
      'senior_mode': 'सीनियर मोड',
      'senior_mode_desc': 'बड़ा पाठ, सरल नेविगेशन',
      'high_contrast': 'उच्च कंट्रास्ट',
      'high_contrast_desc': 'कम दृष्टि के लिए बेहतर दृश्यमानता',
      'language': 'भाषा',
      'notifications': 'सूचनाएं',
      'push_notifications': 'पुश सूचनाएं',
      'push_notifications_desc': 'योजना सतर्कताएं, एस्केलेशन रिमाइंडर',
      'about': 'परिचय',
      'app_version': 'ऐप संस्करण',
      'app_version_value': 'CivicShield v1.0 — हैकाथॉन MVP',
      'legal_notice': 'कानूनी नोटिस',
      'legal_notice_value': 'जुर्माना राशि केवल संकेतात्मक है',
      'privacy': 'गोपनीयता',
      'privacy_value': 'अनाम-प्रथम। डेटा स्थानीय रूप से संग्रहीत।',
      'legal_disclaimers': 'कानूनी अस्वीकरण',
      'emergency_contacts': 'आपातकालीन संपर्क',
      'dark_mode': 'डार्क मोड',
      'dark_mode_desc': 'कम रोशनी में आंखों पर आसान',
      'civil_shield': 'CivicShield',
      'app_name': 'CivicShield',
      'tagline': 'जानिए। सत्यापन करें। मजबूत करें।',
      'sdg_alignment': 'एसडीजी 9 + एसडीजी 16 संरेखित',
      'display': 'प्रदर्शन',
      'home': 'होम',
      'fines': 'जुर्माना चेकर',
      'rights': 'अधिकार और कानून',
      'report': 'दुरुपयोग की रिपोर्ट करें',
      'hotspot': 'कम्युनिटी हॉटस्पॉट',
      'vault': 'साक्ष्य तिजोरी',
      'know_your_rights': 'अपने अधिकार जानें • प्रवर्तन सत्यापित करें',
      'quick_actions': 'त्वरित कार्य',
      'more_tools': 'अधिक उपकरण',
      'quick_tip': 'दैनिक सिविक टिप',
      'challan_tip': 'किसी भी ट्रैफिक जुर्माना का भुगतान करने से पहले हमेशा एक आधिकारिक चालान का अनुरोध करें।',
      'complaint_notice': '1 शिकायत को ध्यान देने की आवश्यकता है',
      'escalate_time': '7 दिन बिना समाधान के — अभी एस्केलेट करें',
      'escalate_btn': 'एस्केलेट करें',
      'fine_checker': 'जुर्माना\nचेकर',
      'fine_checker_sub': '25+ उल्लंघन',
      'know_rights': 'अपने अधिकार\nजानें',
      'know_rights_sub': '8 परिस्थितियाँ',
      'report_misuse': 'केस\nदर्ज करें',
      'report_misuse_sub': 'कानूनी दस्तावेज़ विश्लेषण',
      'community_map': 'समुदाय\nमानचित्र',
      'community_map_sub': '10 हॉटस्पॉट',
      'evidence': 'साक्ष्य\nतिजोरी',
      'evidence_sub': 'संग्रह करें और सुरक्षित करें',
      'schemes': 'सरकारी\nयोजनाएं',
      'schemes_sub': 'लाभ की जानकारी',
      'traffic_fines': 'ट्रैफिक जुर्माना',
      'parking_fines': 'पार्किंग जुर्माना',
      'regulatory_fines': 'नियामक जुर्माना',
      'report_submitted': 'रिपोर्ट जमा की गई!',
      'ai_report': 'एआई द्वारा उत्पन्न रिपोर्ट',
      'submit_report': 'रिपोर्ट सबमिट करें',
      'legal': 'कानूनी\nपरामर्श',
      'legal_sub': 'विशेषज्ञ सलाह',
      'ai_legal': 'एआई कानूनी\nसलाहकार',
      'ai_legal_sub': '🆓 मुफ़्त',
      'close': 'बंद करें',
    },
    'ಕನ್ನಡ (Kannada)': {
      'app_name': 'CivicShield',
      'settings': 'ಸಿದ್ಧತೆಗಳು',
      'accessibility': 'ಪ್ರವೇಶಾಧಿಕಾರ',
      'senior_mode': 'ಸಿನಿಯರ್ ಮೋಡ್',
      'senior_mode_desc': 'ದೊಡ್ಡ ಪಠ್ಯ, ಸರಳ ನ್ಯಾವಿಗೇಶನ್',
      'high_contrast': 'ಹೆಚ್ಚಿನ ವ್ಯತ್ಯಾಸ',
      'high_contrast_desc': 'ನಿಮ್ನ ದೃಷ್ಟಿಕ್ಕೆ ಸುಧಾರಿತ ಗೋಚರತೆ',
      'language': 'ಭಾಷೆ',
      'display': 'ಪ್ರದರ್ಶನ',
      'notifications': 'ಅಧಿಸೂಚನೆಗಳು',
      'push_notifications': 'ಪುಶ್ ಅಧಿಸೂಚನೆಗಳು',
      'push_notifications_desc': 'ಯೋಜನೆ ಎಚ್ಚರಿಕೆಗಳು, ಎಸ್ಕಲೇಶನ್ ಜ್ಞಾಪನೆಗಳು',
      'about': 'ಬಗ್ಗೆ',
      'app_version': 'ಅಪ್ಲಿಕೇಶನ್ ಆವೃತ್ತಿ',
      'app_version_value': 'CivicShield v1.0 — ಹ್ಯಾಕಾಥಾನ್ MVP',
      'legal_notice': 'ಕಾನೂನುಬದ್ಧ ಸೂಚನೆ',
      'legal_notice_value': 'ಪೆನಾಲ್ಟಿ ಮೊತ್ತ ಸೂಚನೀಯ ಮಾತ್ರ',
      'privacy': 'ಗೌಪ್ಯತೆ',
      'privacy_value': 'ಅನಾಮಧೇಯ-ಮೊದಲ. ಡೇಟಾ ಸ್ಥಳೀಯವಾಗಿ ಸಂಗ್ರಹಿಸಲಾಗಿದೆ.',
      'legal_disclaimers': 'ಕಾನೂನುಬದ್ಧ ನಿರಾಕರಣೆಗಳು',
      'emergency_contacts': 'ತುರ್ತುಸನ್ನಿವೇಶ ಸಂಪರ್ಕಗಳು',
      'dark_mode': 'ಕತ್ತಲೆ ಪ್ರಕಾರ',
      'dark_mode_desc': 'ಕಡಿಮೆ ಬೆಳಕಿನಲ್ಲಿ ಕಣ್ಣಿಗೆ ಸುಲಭ',
      'home': 'ಹೋಮ್',
      'fines': 'ಜರಿಮಾನೆ ಪರೀಕ್ಷೆ',
      'rights': 'ಹಕ್ಕುಗಳು ಮತ್ತು ಕಾನೂನುಗಳು',
      'report': 'ದುರುಪಯೋಗವನ್ನು ವರದಿ ಮಾಡಿ',
      'hotspot': 'ಕಮ್ಯುನಿಟಿ ಹಾಟ್‌ಸ್ಪಾಟ್',
      'vault': 'ಸಾಕ್ಷ್ಯ ತಿರಸ್ಕಾರ',
      'know_your_rights': 'ನಿಮ್ಮ ಹಕ್ಕುಗಳನ್ನು ತಿಳಿಯಿರಿ • ಜಾರಿ ಪರಿಶೋಧಿಸಿ',
      'tagline': 'ತಿಳಿಯಿರಿ। ಪರಿಶೀಲಿಸಿ। ಬಲಪಡಿಸಿ।',
      'sdg_alignment': 'SDG 9 + SDG 16 ಜೋಡಿತ',
      'quick_actions': 'ತ್ವರಿತ ಕ್ರಿಯೆಗಳು',
      'more_tools': 'ಹೆಚ್ಚಿನ ಉಪಕರಣಗಳು',
      'quick_tip': 'ದೈನಿಕ ನಾಗರಿಕ ಸಲಹೆ',
      'challan_tip': 'ಯಾವುದೇ ಟ್ರಾಫಿಕ್ ಜರಿಮಾನೆ ಪಾವತಿ ಮಾಡುವ ಮೊದಲು ಯಾವಾಗಲೂ ಅಧಿಕೃತ ಚಾಲನಾ ಕೋರಿ.',
      'complaint_notice': '1 ಮನವಿಗಳು ಗಮನ ಅಗತ್ಯವಿದೆ',
      'escalate_time': '7 ದಿನಗಳು ಪರಿಹಾರ ಇಲ್ಲದೆ — ಈಗ ಎತ್ತರಿಸಿ',
      'escalate_btn': 'ಎತ್ತರಿಸಿ',
      'fine_checker': 'ಜರಿಮಾನೆ\nಪರೀಕ್ಷೆ',
      'fine_checker_sub': '25+ ಉಲ್ಲಂಘನೆ',
      'know_rights': 'ನಿಮ್ಮ ಹಕ್ಕುಗಳನ್ನು\nತಿಳಿಯಿರಿ',
      'know_rights_sub': '8 ಪರಿಸ್ಥಿತಿಗಳು',
      'report_misuse': 'ಪ್ರಕರಣ\nದಾಖಲಿಸಿ',
      'report_misuse_sub': 'ಕಾನೂನು ದಸ್ತಾವೇಜ ವಿಶ್ಲೇಷಣೆ',
      'community_map': 'ಸಮುದಾಯ\nನಕ್ಷೆ',
      'community_map_sub': '10 ಹಾಟ್‌ಸ್ಪಾಟ್',
      'evidence': 'ಸಾಕ್ಷ್ಯ\nತಿರಸ್ಕಾರ',
      'evidence_sub': 'ಸಂಗ್ರಹಣೆ ಮತ್ತು ಸುರಕ್ಷೆ',
      'schemes': 'ಸರ್ಕಾರಿ\nಯೋಜನೆಗಳು',
      'schemes_sub': 'ಸುವಿಧೆಗಳ ಮಾಹಿತಿ',
      'traffic_fines': 'ಟ್ರಾಫಿಕ್ ಜರಿಮಾನೆ',
      'parking_fines': 'ಪಾರ್ಕಿಂಗ್ ಜರಿಮಾನೆ',
      'regulatory_fines': 'ನಿಯಂತ್ರಕ ಜರಿಮಾನೆ',
      'report_submitted': 'ರಿಪೋರ್ಟ ಸಲ್ಲಿಸಲಾಗಿದೆ!',
      'ai_report': 'AI ರೂಪಿದೀಪ ಹತ್ತೋ',
      'submit_report': 'ರಿಪೋರ್ಟ್ ಸಲ್ಲಿಸಿ',
      'legal': 'ಕಾನೂನುಬದ್ಧ\nಸಲಹೆ',
      'legal_sub': 'ವಿಶೇಷಜ್ಞ ಸಲಹೆ',
      'ai_legal': 'AI ಕಾನೂನುಬದ್ಧ\nಸಲಾಹಕಾರ',
      'ai_legal_sub': '🆓 ಉಚಿತ',
      'close': 'ಮುಚ್ಚಿ',
    },
    'தமிழ் (Tamil)': {
      'app_name': 'CivicShield',
      'settings': 'அமைப்புகள்',
      'accessibility': 'அணுகல்தன்மை',
      'senior_mode': 'மூத்தவர் பயன்முறை',
      'senior_mode_desc': 'பெரிய உரை, எளிய வழிசெலுத்தல்',
      'high_contrast': 'உচ்ച மேருபடை',
      'high_contrast_desc': 'குறைந்த பார்வைக்கு மேம்பட்ட தெரிவுநிலை',
      'language': 'மொழி',
      'display': 'காட்சி',
      'notifications': 'அறிவிப்புகள்',
      'push_notifications': 'தள்ளு அறிவிப்புகள்',
      'push_notifications_desc': 'திட்ட எச்சரிக்கைகள், பயணமுறை நினைவூட்டுதல்',
      'about': 'பற்றி',
      'app_version': 'பயன்பாட்டு பதிப்பு',
      'app_version_value': 'CivicShield v1.0 — ஹ்যாக்கதான் MVP',
      'legal_notice': 'சட்ட அறிவிப்பு',
      'legal_notice_value': 'அபராधिਤ€ தொகை இருப்பு மட்டுமே',
      'privacy': 'தனிமை',
      'privacy_value': 'அநாமதேய-முதல். தரவு உள்ளூரில் சேமிக்கப்படுகிறது.',
      'legal_disclaimers': 'சட்ட எச்சரிக்கைகள்',
      'emergency_contacts': 'জরूरत संपर्क',
      'dark_mode': 'இருண்ட முறை',
      'dark_mode_desc': 'குறைந்த வெளிச்சத்தில் கண்களுக்கு எளிது',
      'home': 'வீடு',
      'fines': 'அபராध சரிபார்ப்பு',
      'rights': 'உரிமைகள் மற்றும் சட்டங்கள்',
      'report': 'துஷ்பயன்பாட்டைப் புகாரளிக்கவும்',
      'hotspot': 'சமூக ஹாட்ஸ்பாட்',
      'vault': 'சாக்ষ்யக் களஞ்சியம்',
      'know_your_rights': 'உங்கள் உரிமைகளை தெரிந்துகொள்ளுங்கள் • அமலாக்கம் சரிபார்க்கவும்',
      'tagline': 'தெரிந்துகொள்ளுங்கள். சரிபார்க்கவும். பலப்படுத்துங்கள்.',
      'sdg_alignment': 'SDG 9 + SDG 16 சீரு',      'quick_actions': 'விரைவு நடவடிக்கைகள்',
      'more_tools': 'மேலும் கருவிகள்',
      'quick_tip': 'தினசரி சிவிக் உதவிக்குறிப்பு',
      'challan_tip': 'போக்குவரத்து அபராதத்தை செலுத்தும் முன் எப்போதும் ஒரு அதிகாரப்பூர்வ சாலனத்தை கோரவும்.',
      'complaint_notice': '1 புகாரணைக்கு கவனம் தேவை',
      'escalate_time': '7 நாட்கள் தீர்வு இல்லாமல் — இப்போது பயணமுறை',
      'escalate_btn': 'பயணமுறை',
      'fine_checker': 'அபராத\nசரிபார்ப்பு',
      'fine_checker_sub': '25+ மீறல்கள்',
      'know_rights': 'உங்கள் உரிமைகளை\nதெரிந்துகொள்ளுங்கள்',
      'know_rights_sub': '8 சூழ்நிலைகள்',
      'report_misuse': 'வழக்கை\nதாக்கல் செய்யவும்',
      'report_misuse_sub': 'சட்ட ஆவணம் பகுப்பாய்வு',
      'community_map': 'சமூக\nமபை',
      'community_map_sub': '10 ஹாட்ஸ்பாட்',
      'evidence': 'சாக்ஷ்யக்\nகளஞ்சியம்',
      'evidence_sub': 'சேமிப்பு மற்றும் பாதுகாப்பு',
      'schemes': 'அரசு\nத்திட்டங்கள்',
      'schemes_sub': 'நன்மைக் கோடுவை',
      'traffic_fines': 'போக்குவரத்து அபராதங்கள்',
      'parking_fines': 'பார்க்கிங் அபராதங்கள்',
      'regulatory_fines': 'விதிமுறை அபராதங்கள்',
      'report_submitted': 'பாய் சமர்ப்பிக்கப்பட்டுள்ளது!',
      'ai_report': 'AI உயர்ந்த பாய்',
      'submit_report': 'பாய் சமர்ப்பிக்க',
      'legal': 'சட்ட\nசலாக',
      'legal_sub': 'நிபுணர் ஆலோசனை',
      'ai_legal': 'AI சட்ட\nஆலோசகர்',
      'ai_legal_sub': '🆓 இலவசம்',
      'close': 'மூடு',    },
    'తెలుగు (Telugu)': {
      'app_name': 'CivicShield',
      'settings': 'సెట్టింగ్‌లు',
      'accessibility': 'అందుబాటిత',
      'senior_mode': 'సీనియర్ మోడ్',
      'senior_mode_desc': 'పెద్ద టెక్స్ట్, సరళ నావిగేషన్',
      'high_contrast': 'అధిక కాంట్రాస్ట్',
      'high_contrast_desc': 'తక్కువ దృష్టికి మెరుగైన దృశ్యమానత',
      'language': 'భాష',
      'display': 'ప్రదర్శన',
      'notifications': 'నోటిఫికేషన్‌లు',
      'push_notifications': 'పుష్ నోటిఫికేషన్‌లు',
      'push_notifications_desc': 'యోజన గwarns, ఎస్కలేషన్ రిమైండర్‌లు',
      'about': 'గురించి',
      'app_version': 'అప్ప్ సంస్కరణ',
      'app_version_value': 'CivicShield v1.0 — హ్యాకాథాన్ MVP',
      'legal_notice': 'చట్ట నోటిస్',
      'legal_notice_value': 'జరిమానా మొత్తాలు సూచనకు మాత్రమే',
      'privacy': 'గోప్యతా',
      'privacy_value': 'అనానిమస్-ఫర్స్ట్. డేటా స్థానికంగా నిల్వ చేయబడుతుంది.',
      'legal_disclaimers': 'చట్ట నిరాకరణలు',
      'emergency_contacts': 'ఎమర్జెన్సీ సంప్రదాయలు',
      'dark_mode': 'డార్క్ మోడ్',
      'dark_mode_desc': 'తక్కువ కాంతిలో కళ్లకు సులభం',
      'home': 'హోమ్',
      'fines': 'జరిమానా చెకర్',
      'rights': 'హక్కులు మరియు చట్టాలు',
      'report': 'దుర్వినియోగాన్ని నివేదించండి',
      'hotspot': 'కమ్యూనిటీ హాట్‌స్పాట్',
      'vault': 'సాక్ష్య ఖజానా',
      'know_your_rights': 'మీ హక్కులను తెలుసుకోండి • అమలు సరిచేయండి',
      'tagline': 'తెలుసుకోండి. ధృవీకరించండి. బలంపరచండి.',
      'sdg_alignment': 'SDG 9 + SDG 16 సమన్వయం',
      'quick_actions': 'త్వరిత చర్యలు',
      'more_tools': 'మరిన్ని సాధనాలు',
      'quick_tip': 'రోజువారీ సివిక్ చిట్కా',
      'challan_tip': 'ఏదైనా ట్రాఫిక్ జరిమానాను చెల్లించే ముందు ఎల్లప్పుడూ అధికారిక చాలనను కోరండి.',
      'complaint_notice': '1 ఫిర్యాదు దృష్టిని పట్టుకోవాలి',
      'escalate_time': '7 రోజుల పరిష్కారం లేకుండా — ఇప్పుడు పెరుగుతీ',
      'escalate_btn': 'పెరుగుతీ',
      'fine_checker': 'జరిమానా\nచెకర్',
      'fine_checker_sub': '25+ ఉల్లంఘనలు',
      'know_rights': 'మీ హక్కులను\nతెలుసుకోండి',
      'know_rights_sub': '8 సందర్భాలు',
      'report_misuse': 'కేసు\nఫైల్ చేయండి',
      'report_misuse_sub': 'చట్ట ప్రলेఖ విశ్లేషణ',
      'community_map': 'సమాజం\nమ్యాప్',
      'community_map_sub': '10 హాట్‌స్పాట్‌',
      'evidence': 'సాక్ష్య\nఖజానా',
      'evidence_sub': 'నిల్వ మరియు సురక్షిత',
      'schemes': 'ప్రభుత్వ\nథీమ్‌లు',
      'schemes_sub': 'ప్రయోజనాల సమాచారం',
      'traffic_fines': 'ట్రాఫిక్ జరిమానాలు',
      'parking_fines': 'పార్కింగ్ జరిమానాలు',
      'regulatory_fines': 'నియంత్రక జరిమానాలు',
      'report_submitted': 'ఫిర్యాది సమర్పించబడింది!',
      'ai_report': 'AI ఉత్పత్తి ఫిర్యాది',
      'submit_report': 'ఫిర్యాది సమర్పించండి',
      'legal': 'చట్ట\nసలహా',
      'legal_sub': 'నిపుణ సలాహ',
      'ai_legal': 'AI చట్ట\nపరामర్శదాత',
      'ai_legal_sub': '🆓 ఉచితం',
      'close': 'ఆపండి',
    },
    'मराठी (Marathi)': {
      'app_name': 'CivicShield',
      'settings': 'सेटिंग्‍स',
      'accessibility': 'अ‍ॅक्सेसिबिलिटी',
      'senior_mode': 'सीनियर मोड',
      'senior_mode_desc': 'मोठे मजकूर, सरल नेव्हिगेशन',
      'high_contrast': 'उच्च कंट्रास्ट',
      'high_contrast_desc': 'कमजोर दृष्टीसाठी वर्धित दृश्यमानता',
      'language': 'भाषा',
      'display': 'प्रदर्शन',
      'notifications': 'सूचना',
      'push_notifications': 'पुश सूचना',
      'push_notifications_desc': 'योजना सतर्कता, एस्कलेशन रिमाइंडर',
      'about': 'विषयी',
      'app_version': 'ऍप आवृत्ती',
      'app_version_value': 'CivicShield v1.0 — हॅकाथॉन MVP',
      'legal_notice': 'कायदेशीर सूचना',
      'legal_notice_value': 'दंड रक्कम केवळ सूचक आहे',
      'privacy': 'गोपनीयता',
      'privacy_value': 'अनामस-प्रथम. डेटा स्थानिकरित्या संग्रहीत केला जातो.',
      'legal_disclaimers': 'कायदेशीर अस्वीकरण',
      'emergency_contacts': 'आपातकालीन संपर्क',
      'dark_mode': 'गोधूळ मोड',
      'dark_mode_desc': 'कमी प्रकाशात डोळ्यांना सुलभ',
      'home': 'गृह',
      'fines': 'दंड तपासणी',
      'rights': 'हक्क आणि कायदे',
      'report': 'गैरवापर अहवाल द्या',
      'hotspot': 'समुदाय हॉटस्पॉट',
      'vault': 'पुरावा तिजोरी',
      'know_your_rights': 'आपले हक्क जाणून घ्या • अंमलबजावणी सत्यापित करा',
      'tagline': 'जाणून घ्या. सत्यापित करा. मजबूत करा.',
      'sdg_alignment': 'SDG 9 + SDG 16 संरेखित',
      'quick_actions': 'त्वरित कार्य',
      'more_tools': 'अधिक साधने',
      'quick_tip': 'दैनिक नागरिक सूचना',
      'challan_tip': 'कोणतेही ट्रेफिक दंड भरण्यापूर्वी नेहमी अधिकृत चालान मागा.',
      'complaint_notice': '1 तक्रार लक्ष्य देणे आवश्यक आहे',
      'escalate_time': '7 दिवसांपर्यंत निराकरण न होता — आता वर करा',
      'escalate_btn': 'वर करा',
      'fine_checker': 'दंड\nतपासणी',
      'fine_checker_sub': '25+ उल्लंघन',
      'know_rights': 'आपले हक्क\nजाणून घ्या',
      'know_rights_sub': '8 परिस्थिती',
      'report_misuse': 'प्रकरण\nदाखल करा',
      'report_misuse_sub': 'कायदेशीर कागदपत्र विश्लेषण',
      'community_map': 'समुदाय\nमानचित्र',
      'community_map_sub': '10 हॉटस्पॉट',
      'evidence': 'पुरावा\nतिजोरी',
      'evidence_sub': 'संग्रहीत करा आणि सुरक्षित करा',
      'schemes': 'सरकार\nयोजना',
      'schemes_sub': 'लाभ माहिती',
      'traffic_fines': 'ट्रेफिक दंड',
      'parking_fines': 'पार्किंग दंड',
      'regulatory_fines': 'नियामक दंड',
      'report_submitted': 'अहवाल जमा केला गेला!',
      'ai_report': 'AI तयार अहवाल',
      'submit_report': 'अहवाल सबमिट करा',
      'legal': 'कायदेशीर\nसल',
      'legal_sub': 'तज्ञ सल',
      'ai_legal': 'AI कायदेशीर\nसलाहकार',
      'ai_legal_sub': '🆓 विनामूल्य',
      'close': 'बंद करा',
    },
  };

  static String translate(String key, String language) {
    return translations[language]?[key] ?? translations['English']?[key] ?? key;
  }
}
