import 'package:flutter/material.dart';

abstract class AppStrings {
  static const defaultLanguage = 'en';
  static const supportedLanguages = ['en', 'kn', 'hi'];

  // Home Screen
  static const Map<String, String> homeTitle = {
    'en': 'Home',
    'kn': 'ಮರೆತೆ',
    'hi': 'होम',
  };

  static const Map<String, String> goodEveningCitizen = {
    'en': 'Good evening, Citizen.',
    'kn': 'ಸುಸ್ವಾಗತ, ನಾಗರಿಕ.',
    'hi': 'शुभ संध्या, नागरिक।',
  };

  static const Map<String, String> knowYourRights = {
    'en': 'Know your rights.\nAct with confidence.',
    'kn': 'ನಿಮ್ಮ ಹಕ್ಕುಗಳನ್ನು ತಿಳಿಯಿರಿ.\nಆತ್ಮವಿಶ್ವಾಸದೊಂದಿಗೆ ಕಾರ್ಯ ನಿರ್ವಹಿಸಿ.',
    'hi': 'अपने अधिकार जानें।\nआत्मविश्वास के साथ कार्य करें।',
  };

  // Fine Checker
  static const Map<String, String> fineChecker = {
    'en': 'Fine Checker',
    'kn': 'ಫೈನ್ ಚೆಕರ್',
    'hi': 'जुर्माना चेकर',
  };

  static const Map<String, String> searchViolation = {
    'en': 'Search for a violation...',
    'kn': 'ಉಲ್ಲಂಘನೀಯತೆಯನ್ನು ಹುಡುಕಿ...',
    'hi': 'किसी उल्लंघन की खोज करें...',
  };

  static const Map<String, String> officialFineAmount = {
    'en': 'Official Fine Amount',
    'kn': 'ಅಧಿಕೃತ ಜುರ್ಮಾನೆ',
    'hi': 'आधिकारिक जुर्माना राशि',
  };

  // File Case Assistant
  static const Map<String, String> reportMisuse = {
    'en': 'File Case',
    'kn': 'ಪ್ರಕರಣ ದಾಖಲಿಸಿ',
    'hi': 'केस दर्ज करें',
  };

  static const Map<String, String> submissionSuccess = {
    'en': 'Report submitted successfully',
    'kn': 'ವರದಿ ಯಶಸ್ವಿಯಾಗಿ ಸಲ್ಲಿಸಿದವು',
    'hi': 'रिपोर्ट सफलतापूर्वक जमा की गई',
  };

  // Authority Directory
  static const Map<String, String> authorityDirectory = {
    'en': 'Authority Directory',
    'kn': 'ಅಧಿಕೃತ ನಿರ್ದೇಶಿಕೆ',
    'hi': 'प्राधिकार निर्देशिका',
  };

  static const Map<String, String> searchAuthorities = {
    'en': 'Search authorities, services...',
    'kn': 'ಅಧಿಕಾರಗಳು, ಸೇವೆಗಳನ್ನು ಹುಡುಕಿ...',
    'hi': 'प्राधिकारों, सेवाओं की खोज करें...',
  };

  // Analytics
  static const Map<String, String> analyticsTitle = {
    'en': 'Analytics & Insights',
    'kn': 'ವಿಶ್ಲೇಷಣೆ ಮತ್ತು ಅಡಿಕೆ',
    'hi': 'विश्लेषण और अंतर्दृष्टि',
  };

  static const Map<String, String> yourReports = {
    'en': 'Your Reports',
    'kn': 'ನಿಮ್ಮ ವರದಿಗಳು',
    'hi': 'आपकी रिपोर्टें',
  };

  // Common
  static const Map<String, String> callNow = {
    'en': 'Call Now',
    'kn': 'ಈಗ ಕರೆ ಮಾಡಿ',
    'hi': 'अभी कॉल करें',
  };

  static const Map<String, String> submit = {
    'en': 'Submit',
    'kn': 'ಸಲ್ಲಿಸಿ',
    'hi': 'जमा करें',
  };

  static const Map<String, String> cancel = {
    'en': 'Cancel',
    'kn': 'ರದ್ದುಮಾಡಿ',
    'hi': 'रद्द करें',
  };

  static const Map<String, String> save = {
    'en': 'Save',
    'kn': 'ಉಳಿಸಿ',
    'hi': 'सहेजें',
  };

  static const Map<String, String> loading = {
    'en': 'Loading...',
    'kn': 'ಲೋಡ್ ಆಗುತ್ತಿದೆ...',
    'hi': 'लोड हो रहा है...',
  };

  // Get string by language
  static String getString(Map<String, String> stringMap, String languageCode) {
    return stringMap[languageCode] ?? stringMap[defaultLanguage] ?? '';
  }
}

class AppLocalization {
  static const List<Locale> supportedLocales = [
    Locale('en', ''),
    Locale('kn', ''),
    Locale('hi', ''),
  ];

  static Locale getLocale(String languageCode) {
    switch (languageCode) {
      case 'kn':
        return const Locale('kn', '');
      case 'hi':
        return const Locale('hi', '');
      default:
        return const Locale('en', '');
    }
  }

  static String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'kn':
        return 'ಕನ್ನಡ';
      case 'hi':
        return 'हिन्दी';
      default:
        return 'English';
    }
  }
}
