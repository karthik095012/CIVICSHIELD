<div align="center">

<img src="https://img.shields.io/badge/🛡️-CivicShield-00796B?style=for-the-badge&labelColor=0D1B2A" />

# CivicShield

### *Know Your Rights. Verify Enforcement. Strengthen Accountability.*

<p>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" /></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white" /></a>
  <a href="https://riverpod.dev"><img src="https://img.shields.io/badge/Riverpod-2.x-00D2FF" /></a>
  <a href="https://supabase.com"><img src="https://img.shields.io/badge/Supabase-Optional-3ECF8E?logo=supabase" /></a>
  <img src="https://img.shields.io/badge/License-MIT-27AE60" />
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20macOS-lightgrey" />
  <img src="https://img.shields.io/badge/SDG-9%20%2B%2016-3498DB" />
</p>

**CivicShield** is a civic empowerment Flutter application for Indian citizens —  
putting law knowledge, enforcement accountability, and community action in every citizen's pocket.

> Hackathon MVP · Aligned with UN SDG 9 (Innovation) & SDG 16 (Justice & Accountability)

</div>

---

## 📋 Table of Contents

| # | Section |
|---|---------|
| 1 | [What is CivicShield?](#-what-is-civicshield) |
| 2 | [Features at a Glance](#-features-at-a-glance) |
| 3 | [All Screens — Detailed](#-all-screens--detailed) |
| 4 | [Tech Stack](#-tech-stack) |
| 5 | [Architecture Deep Dive](#-architecture-deep-dive) |
| 6 | [Complete Project Structure](#-complete-project-structure) |
| 7 | [Data Layer & JSON Schemas](#-data-layer--json-schemas) |
| 8 | [Design System](#-design-system) |
| 9 | [Prerequisites & Environment Setup](#-prerequisites--environment-setup) |
| 10 | [Installation — Step by Step](#-installation--step-by-step) |
| 11 | [Running the App](#-running-the-app) |
| 12 | [Backend Setup (Supabase)](#-backend-setup-supabase) |
| 13 | [Building for Production](#-building-for-production) |
| 14 | [Troubleshooting](#-troubleshooting) |
| 15 | [Roadmap](#-roadmap) |
| 16 | [Contributing](#-contributing) |
| 17 | [Legal Disclaimers](#-legal-disclaimers) |
| 18 | [License](#-license) |

---

## 🌟 What is CivicShield?

Most Indian citizens face enforcement interactions without knowing:
- Whether a fine amount quoted to them is correct under law
- What their legal rights are during a traffic stop or police check
- How to safely document and report misconduct or bribery
- Which government schemes they are entitled to

**CivicShield bridges this gap** with a single app that is:

- 📴 **Offline-first** — core features work without internet (data is bundled locally)
- 🔒 **Privacy-first** — anonymous reporting, local storage, no account required
- ♿ **Accessibility-first** — Senior Mode, High Contrast Mode, WCAG 2.1 AA compliant
- 🌐 **Multilingual** — English, Hindi, Kannada, Tamil, Telugu, Marathi (foundation ready)
- ⚖️ **Law-accurate** — all fine amounts reference the Motor Vehicles (Amendment) Act 2019

---

## ✨ Features at a Glance

| Module | What It Does | Status |
|--------|-------------|--------|
| ⚖️ Fine Checker | Search 25+ Karnataka traffic violations with verified fine amounts, law sections, repeat offense penalties, and process guidance | ✅ MVP |
| 📜 Know Your Rights | 8 scenario-based rights cards with Do/Don't/Myths tabs and emergency contacts | ✅ MVP |
| 📢 Report Misuse | 6-step guided wizard to document enforcement misconduct → AI-formatted professional complaint letter | ✅ MVP |
| 🗺️ Community Hotspot | Crowdsourced map of enforcement concern zones — list view + Bengaluru canvas map | ✅ MVP |
| 🔒 Evidence Vault | Secure local incident records with AI summary, status tracking, delete & export | ✅ MVP |
| 🏛️ Govt Schemes | 12 central/state schemes with eligibility, benefits, deadlines, bookmarking, Apply Now | ✅ MVP |
| 📊 Analytics | Personal + community incident statistics, monthly trends, resolution rates | ✅ MVP |
| 🏢 Authority Directory | Searchable government authority database with call/email integration | ✅ MVP |
| 🧑‍⚖️ Legal Services | Nearby legal aid centres — NALSA empanelled providers | ✅ MVP |
| ⚙️ Settings | Dark mode, Senior Mode, High Contrast, language picker, emergency contacts | ✅ MVP |

---

## 📱 All Screens — Detailed

### 1. 💫 Splash Screen (`/splash`)
- Animated CivicShield shield logo with pulsing saffron-cyan glow
- Dot-grid background with civic branding
- Three-line tagline: *Know Your Rights. Verify Enforcement. Strengthen Accountability.*
- SDG badge and loading indicator
- Auto-navigates to Home after 2.8 seconds

---

### 2. 🏠 Home Dashboard (`/home`)
- **Escalation Alert Banner** — fires when a saved complaint hits Day 7, 14, or 30 without resolution (red banner with escalate CTA)
- **Daily Civic Tip** — rotating actionable tips about citizen rights
- **4-Card Quick Action Grid**:
  - ⚖️ Fine Checker (25+ violations)
  - 📜 Know Your Rights (8 scenarios)
  - 📢 Report Misuse (guided form)
  - 🗺️ Community Map (hotspots)
- **Secondary Action Tiles** — Evidence Vault, Govt Schemes
- Mandatory legal disclaimer footer

---

### 3. ⚖️ Fine Checker (`/fines`)
- **Live search** across violation name, description, and category
- **Horizontal category chips** — helmet, seatbelt, mobile, drunk_driving, signal, speeding, documents, parking, emission, number_plate, lane, overloading, horn, tinted_glass, school_zone, pedestrian, minor_driving
- **Expandable violation cards** showing:
  - 1st offense fine amount (large, color-coded)
  - Repeat offense fine amount (in red)
  - Full law reference with Act section number
  - "What should happen?" — the correct legal process
  - "Important Note" — suspension, imprisonment, etc.
- Empty state with clear illustration

---

### 4. 📜 Know Your Rights (`/rights`)
- **8 scenario cards** with color-coded category badge
- **Expandable with 3 tabs**:
  - ✅ *What TO Do* — actionable guidance
  - ❌ *What NOT To Do* — common mistakes to avoid
  - 💡 *Myths vs Facts* — myth and verified fact pairs
- Per-card **Emergency Contacts** section (phone numbers)
- Animated expand/collapse

**Scenarios covered:**

| # | Scenario | Category |
|---|----------|----------|
| 1 | During a Traffic Stop | Traffic |
| 2 | Challan & Receipt Rights | Traffic |
| 3 | Bribery & Misconduct | Anti-Corruption |
| 4 | Right to Information (RTI) | RTI |
| 5 | Consumer Rights | Consumer |
| 6 | Women's Safety Rights | Women |
| 7 | Free Legal Aid Entitlement | Legal |
| 8 | FIR & Police Complaint Rights | Police |

---

### 5. 📢 Report Misuse Assistant (`/report`)
A **6-step animated wizard** with slide transition between steps and a progress bar:

| Step | Content |
|------|---------|
| 1 | Issue type selection — Overcharging / No Receipt / Bribe Request / Wrong Fine / Harassment / Misleading Info |
| 2 | Violation category — Traffic, Parking, Consumer, Healthcare, Municipal, Property, Other |
| 3 | Amount demanded (₹) + Amount paid (₹) + Receipt given toggle |
| 4 | Location name + Date/Time (auto) + Anonymous toggle |
| 5 | Free-text incident description |
| 6 | Review summary → Submit |

**On submission:**
- Generates an AI-structured complaint letter
- Saves to Evidence Vault (local persistence)
- Displays recommended next steps (ACB contact, complaint portal)
- Success screen with View Vault / New Report options

---

### 6. 🗺️ Community Hotspot (`/hotspot`)
**Two tabs:**

**List View:**
- Stats bar — Total / Active / High Severity counts
- Hotspot cards with:
  - Left-border severity color coding (Red/Orange/Green)
  - Report count (large number)
  - Area name, issue category, description
  - Days unresolved indicator with timer icon
  - **"I Experienced This Too"** button — animated, prevents double-support
  - RESOLVED badge for closed hotspots

**Map View:**
- Bengaluru canvas grid map with styled road lines
- Color-coded circular markers per hotspot (severity-based glow)
- Report count label under each marker
- Tap marker → Bottom sheet with full details
- Severity legend (Red/Orange/Green)

---

### 7. 🔒 Evidence Vault (`/vault`)
- Encrypted local storage of all submitted incident reports
- **Report card** showing:
  - Issue type and violation category
  - Status badge — Saved / Submitted / Exported / Unresolved
  - Amount demanded, location, timestamp
  - Notes preview (truncated)
  - AI Summary chip → opens draggable bottom sheet with full formatted complaint
  - Delete button
  - Anonymous/Named indicator
- Empty state with vault explanation
- **FAB** to add new incident manually
- Vault Info dialog explaining privacy model (local-only, no server)

---

### 8. 🏛️ Government Schemes (`/schemes`)
- **Category filter chips** — All, Agriculture, Health, Housing, Women & Child, Business/MSME, Senior Citizens, Education, Disability
- **Bookmark** toggle (★) with filter to show bookmarked only
- **Scheme cards** with:
  - Category color-coded header gradient
  - Scheme name + category badge
  - Description
  - Benefit amount (highlighted)
  - Eligibility criteria
  - Application deadline
  - State / All India scope
  - **Apply Now** button → opens official government portal in browser

---

### 9. 📊 Analytics Dashboard (`/analytics`)
- Personal statistics panel — total incidents, resolution rate, most reported issue
- Community impact metrics — total community reports, hotspot count, avg severity
- Severity breakdown (High / Medium / Low pie/bar)
- Monthly trend visualization
- Top hotspot identification
- Issue category analysis

---

### 10. 🏢 Authority Directory (`/authorities`)
- Search bar across authority name and description
- Filter by category — Traffic, Consumer, Anti-Corruption, Legal Aid, Women Safety, General
- **Authority cards** with:
  - Category badge + icon
  - Services offered
  - Community helpfulness count
  - **Call** and **Email** action buttons

---

### 11. ⚙️ Settings (`/settings`)
- **Dark Mode toggle** (persisted via SharedPreferences)
- **Senior Mode toggle** — scales all text 1.2× globally via MediaQuery
- **High Contrast Mode toggle** — flips to high-contrast color scheme
- **Language selector** — English, हिंदी, ಕನ್ನಡ, தமிழ், తెలుగు, मराठी
- App version info
- Privacy policy link
- Mandatory legal disclaimers
- **Emergency Contacts directory** with call buttons:
  - Police Emergency — 100
  - Women's Helpline — 1091
  - NALSA Legal Aid — 15100
  - Anti-Corruption Bureau — 1064
  - National Consumer Helpline — 1800-11-4000
  - Unified Emergency — 112

---

## 🛠 Tech Stack

### Core

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter` | 3.x | UI framework |
| `dart` | 3.x | Language |
| `flutter_riverpod` | ^2.5.1 | State management (StateNotifier) |
| `go_router` | ^13.2.0 | Declarative navigation + Shell routes |

### Storage & Data

| Package | Version | Purpose |
|---------|---------|---------|
| `hive` | ^2.2.3 | NoSQL on-device key-value store |
| `hive_flutter` | ^1.1.0 | Flutter adapter for Hive |
| `shared_preferences` | ^2.2.3 | User settings persistence (dark mode, senior mode, etc.) |
| `path_provider` | ^2.1.3 | File system paths for asset storage |

### UI & Fonts

| Package | Version | Purpose |
|---------|---------|---------|
| `google_fonts` | ^6.2.1 | Nunito typeface (dynamically loaded) |
| `cached_network_image` | ^3.3.1 | Cached image loading |
| `flutter_map` | ^6.1.0 | Map rendering (flutter_map provider) |
| `latlong2` | ^0.9.0 | Geo coordinate model for maps |

### Utilities

| Package | Version | Purpose |
|---------|---------|---------|
| `intl` | ^0.19.0 | Date/time formatting, i18n |
| `uuid` | ^4.3.3 | Unique ID generation for reports |
| `url_launcher` | ^6.2.6 | Open government portals in browser |
| `share_plus` | ^9.0.0 | Share complaint summaries |
| `image_picker` | ^1.1.2 | Attach evidence photos |
| `http` | ^1.1.0 | HTTP requests |

### Backend (Optional)

| Package | Version | Purpose |
|---------|---------|---------|
| `supabase_flutter` | ^2.4.0 | Cloud sync for reports (optional) |

### Dev Tools

| Package | Version | Purpose |
|---------|---------|---------|
| `hive_generator` | ^2.0.1 | Code-gen for Hive TypeAdapters |
| `build_runner` | ^2.4.8 | Code generation runner |
| `flutter_lints` | ^3.0.0 | Lint rules |
| `flutter_launcher_icons` | ^0.14.3 | Generate app icons for all platforms |

---

## 🏗 Architecture Deep Dive

### Layer Overview

```
┌──────────────────────────────────────────────────────┐
│                  Presentation Layer                  │
│  Screens (Flutter Widgets) · GoRouter · Riverpod UI  │
├──────────────────────────────────────────────────────┤
│                   Domain Layer                       │
│       Providers (StateNotifier) · Business Logic     │
├──────────────────────────────────────────────────────┤
│                    Data Layer                        │
│  JSON Assets · SharedPreferences · Hive · Supabase   │
└──────────────────────────────────────────────────────┘
```

### State Management — Riverpod Providers

All state is managed through typed `StateNotifierProvider`s:

```dart
// ── Data Providers ──────────────────────────────────────────────
fineProvider               → StateNotifier<AsyncValue<List<FineModel>>>
rightsProvider             → StateNotifier<AsyncValue<List<RightsCardModel>>>
reportProvider             → StateNotifier<List<IncidentReportModel>>
hotspotProvider            → StateNotifier<AsyncValue<List<HotspotModel>>>
schemeProvider             → StateNotifier<AsyncValue<List<SchemeModel>>>
authorityProvider          → StateNotifier<AsyncValue<List<AuthorityModel>>>
analyticsProvider          → StateNotifier<AnalyticsModel>
complaintSummaryProvider   → StateNotifier<List<ComplaintSummaryModel>>
legalServicesProvider      → StateNotifier<AsyncValue<List<LegalServiceLocationModel>>>
legalNewsProvider          → StateNotifier<AsyncValue<List<LegalNewsModel>>>
documentAnalysisProvider   → StateNotifier<DocumentAnalysisState>
legalDocumentsProvider     → StateNotifier<AsyncValue<List<LegalDocumentModel>>>

// ── Auth Provider ────────────────────────────────────────────────
authProvider               → StateNotifier<AuthState>  (Supabase-backed)

// ── Preferences Providers (persisted via SharedPreferences) ──────
themeModeProvider          → StateNotifier<bool>   // isDarkMode
seniorModeProvider         → StateNotifier<bool>   // isSeniorMode
highContrastProvider       → StateNotifier<bool>   // isHighContrast
```

### Navigation — GoRouter Tree

```
/splash                    → SplashScreen (no bottom nav)
│
└── ShellRoute (MainShell — BottomNavigationBar)
    ├── /home              → HomeDashboardScreen
    ├── /fines             → FineCheckerScreen
    ├── /rights            → RightsCardsScreen
    ├── /report            → ReportAssistantScreen
    ├── /hotspot           → CommunityHotspotScreen
    ├── /vault             → EvidenceVaultScreen
    ├── /schemes           → SchemesScreen
    ├── /analytics         → AnalyticsDashboardScreen
    ├── /authorities       → AuthorityDirectoryScreen
    ├── /legal-services    → LegalServicesScreen
    ├── /news              → LegalNewsScreen
    └── /settings          → SettingsScreen
```

### App Entry Point

```dart
// lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SupabaseService.instance.initialize();   // optional, safe if unconfigured
  runApp(const ProviderScope(child: CivicShieldApp()));
}

// CivicShieldApp reads 3 providers at root:
//   themeModeProvider    → isDarkMode
//   seniorModeProvider   → scale text ×1.2
//   highContrastProvider → high contrast color scheme
// These are applied globally via MaterialApp.router + MediaQuery builder
```

### Theme System

The `CivicShieldTheme` class provides a fully dynamic theme:

```dart
// Light / Dark / High Contrast all from one function:
CivicShieldTheme.getTheme(isDarkMode: bool, isHighContrast: bool)

// Color tokens:
CivicShieldTheme.primaryDeepTeal   // #00796B
CivicShieldTheme.accentCyan        // #00BCD4
CivicShieldTheme.successGreen      // #27AE60
CivicShieldTheme.dangerRed         // #E74C3C
CivicShieldTheme.warningOrange     // #F39C12
CivicShieldTheme.infoBlue          // #3498DB

// Utility methods:
CivicShieldTheme.severityColor('high')        // → Color
CivicShieldTheme.categoryColor('traffic')     // → Color
CivicShieldTheme.categoryIcon('helmet')       // → IconData
CivicShieldTheme.issueIcon('bribe_request')   // → IconData
CivicShieldTheme.severityGradient('medium')   // → LinearGradient
```

---

## 📁 Complete Project Structure

```
civicshield/
│
├── lib/
│   ├── main.dart                                  # Entry point — ProviderScope + Supabase init
│   │
│   ├── app/
│   │   ├── theme.dart                             # CivicShieldTheme — colors, gradients, icons
│   │   └── router.dart                            # GoRouter config + MainShell + BottomNav
│   │
│   ├── models/                                    # Pure Dart data models
│   │   ├── fine_model.dart                        # Traffic violation
│   │   ├── rights_card_model.dart                 # Rights scenario card
│   │   ├── hotspot_model.dart                     # Community hotspot
│   │   ├── scheme_model.dart                      # Government scheme
│   │   ├── incident_report_model.dart             # User-submitted report
│   │   ├── authority_model.dart                   # Government authority
│   │   ├── analytics_model.dart                   # Analytics stats
│   │   ├── complaint_summary_model.dart           # AI complaint letter
│   │   ├── auth_models.dart                       # Auth state
│   │   ├── legal_service_location_model.dart      # Legal aid centre
│   │   ├── legal_news_model.dart                  # Civic news article
│   │   ├── legal_document_model.dart              # Legal document reference
│   │   └── document_analysis_model.dart           # Document AI analysis
│   │
│   ├── providers/                                 # Riverpod state notifiers
│   │   ├── fine_provider.dart
│   │   ├── rights_provider.dart
│   │   ├── report_provider.dart
│   │   ├── hotspot_provider.dart
│   │   ├── scheme_provider.dart
│   │   ├── authority_provider.dart
│   │   ├── analytics_provider.dart
│   │   ├── complaint_summary_provider.dart
│   │   ├── auth_provider.dart                     # Supabase auth
│   │   ├── preferences_provider.dart              # Theme/Senior/HighContrast (SharedPrefs)
│   │   ├── legal_services_provider.dart
│   │   ├── legal_news_provider.dart
│   │   ├── legal_documents_provider.dart
│   │   └── document_analysis_provider.dart
│   │
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── home/
│   │   │   └── home_dashboard_screen.dart
│   │   ├── fine_checker/
│   │   │   └── fine_checker_screen.dart
│   │   ├── rights/
│   │   │   └── rights_cards_screen.dart
│   │   ├── report/
│   │   │   └── report_assistant_screen.dart
│   │   ├── hotspot/
│   │   │   └── community_hotspot_screen.dart
│   │   ├── evidence_vault/
│   │   │   └── evidence_vault_screen.dart
│   │   ├── schemes/
│   │   │   └── schemes_screen.dart
│   │   ├── analytics/
│   │   │   └── analytics_dashboard_screen.dart
│   │   ├── authority_directory/
│   │   │   └── authority_directory_screen.dart
│   │   ├── legal_services/
│   │   ├── legal_consultancy/
│   │   ├── ai_legal_consultancy/
│   │   ├── news/
│   │   ├── auth/
│   │   ├── onboarding/
│   │   └── settings/
│   │       └── settings_screen.dart
│   │
│   ├── widgets/                                   # Reusable components
│   │   ├── custom_button.dart                     # ElevatedButton + loading state
│   │   ├── custom_cards.dart                      # GlassCard, InfoCard, StatCard
│   │   ├── severity_badge.dart                    # High/Medium/Low badge
│   │   ├── custom_text_field.dart                 # Validated input field
│   │   ├── section_header.dart                    # Consistent section headings
│   │   └── progress_indicator_custom.dart         # Step progress widget
│   │
│   ├── services/
│   │   └── supabase_service.dart                  # Supabase singleton init
│   │
│   ├── repositories/                              # Data access layer
│   ├── config/                                    # App configuration constants
│   └── utils/
│       └── app_strings.dart                       # Multilingual string keys
│
├── assets/
│   ├── data/
│   │   ├── fines.json                             # 25 Karnataka traffic violations
│   │   ├── rights_cards.json                      # 8 rights scenario cards
│   │   ├── hotspots.json                          # 10 Bengaluru hotspots
│   │   ├── schemes.json                           # 12 government schemes
│   │   └── legal_services.json                    # Legal aid centre directory
│   ├── images/                                    # App logo, illustrations
│   └── fonts/                                     # (optional, Google Fonts used instead)
│
├── android/                                       # Android platform code
├── ios/                                           # iOS platform code
├── web/                                           # Web platform (index.html, manifest)
├── macos/                                         # macOS platform (entitlements)
│
├── test/
│   └── widget_test.dart                           # Smoke test
│
├── pubspec.yaml                                   # Dependencies + asset declarations
├── analysis_options.yaml                          # Lint rules
└── README.md
```

---

## 🗃 Data Layer & JSON Schemas

All MVP data is bundled as local JSON assets — **no server needed for the demo**.

### `assets/data/fines.json`

25 Karnataka traffic violations. Full schema:

```json
{
  "id": "f001",
  "category": "helmet",
  "violation_name": "Riding Without Helmet",
  "description": "Two-wheeler rider/pillion not wearing ISI-marked helmet on head while riding",
  "fine_amount": 1000,
  "repeat_offense_amount": 2000,
  "repeat_offense_note": "Second offense attracts double fine + 3 month licence suspension",
  "law_reference": "Section 129, Motor Vehicles Act 1988 (Amended 2019)",
  "state_scope": "Karnataka (Pan-India base rate)",
  "source": "Karnataka Traffic Police — Official Challan Schedule",
  "first_offense_note": "Disqualification of licence for 3 months on repeat",
  "process": "Officer must issue official challan. You have 60 days to pay at a court or online at parivahan.gov.in. No cash should be collected on spot without a receipt.",
  "is_bailable": true,
  "imprisonment_possible": false
}
```

**Categories:** `helmet` `seatbelt` `mobile` `drunk_driving` `signal` `speeding` `documents` `parking` `emission` `number_plate` `lane` `overloading` `horn` `tinted_glass` `school_zone` `pedestrian` `minor_driving`

---

### `assets/data/rights_cards.json`

8 scenario cards. Full schema:

```json
{
  "id": "r001",
  "title": "During a Traffic Stop",
  "category": "traffic",
  "summary": "What you can and cannot be asked to do during a routine traffic check",
  "details": "Full legal explanation of officer powers and citizen rights...",
  "dos": [
    "Stay calm and pull over safely",
    "Ask for the officer's name and badge number",
    "Request an official challan in writing"
  ],
  "donts": [
    "Do NOT hand over your original RC book — a photocopy is sufficient",
    "Do NOT pay cash without an official receipt",
    "Do NOT argue aggressively — document instead"
  ],
  "myths": [
    {
      "myth": "Officers can impound your vehicle for any reason",
      "fact": "Impoundment requires a valid court order or specific notified violations"
    }
  ],
  "emergency_contacts": [
    "Traffic Control Room: 103",
    "Karnataka Police: 100",
    "ACB Karnataka: 1064"
  ],
  "law_references": ["MV Act Section 130", "MV Act Section 203"]
}
```

---

### `assets/data/hotspots.json`

10 Bengaluru enforcement hotspots:

```json
{
  "id": "h001",
  "area_name": "Silk Board Junction",
  "landmark": "Near Silk Board Bus Stop",
  "lat": 12.9174,
  "lng": 77.6231,
  "issue_category": "overcharging",
  "report_count": 47,
  "support_count": 23,
  "severity_level": "high",
  "days_unresolved": 21,
  "status": "active",
  "description": "Multiple reports of traffic enforcement officers collecting fines without issuing official challans. Amounts range ₹500–₹2000 informally.",
  "created_at": "2026-03-15T08:00:00Z"
}
```

**Issue categories:** `overcharging` `no_receipt` `bribe_request` `pothole` `streetlight` `garbage`  
**Status values:** `active` `investigating` `resolved`  
**Severity values:** `high` `medium` `low`

---

### `assets/data/schemes.json`

12 central/state government schemes:

```json
{
  "id": "s001",
  "name": "PM-KISAN Samman Nidhi",
  "category": "Agriculture",
  "description": "Income support of ₹6,000/year to all land-holding farmer families across India.",
  "benefit_amount": "₹6,000/year (₹2,000 per installment × 3)",
  "eligibility": "All landholding farmer families with cultivable land",
  "deadline": "Ongoing — apply anytime",
  "state_scope": "All India",
  "official_link": "https://pmkisan.gov.in",
  "is_bookmarked": false
}
```

**Categories:** `Agriculture` `Health` `Housing` `Women & Child` `Business/MSME` `Senior Citizens` `Education` `Disability`

---

### `assets/data/legal_services.json`

Legal aid centre directory:

```json
{
  "id": "ls001",
  "name": "Karnataka State Legal Services Authority",
  "type": "NALSA Empanelled",
  "address": "High Court of Karnataka, Bengaluru 560001",
  "phone": "080-22111714",
  "email": "kslsa@karnataka.gov.in",
  "services": ["Free Legal Aid", "Lok Adalat", "Pre-Litigation Mediation"],
  "lat": 12.9789,
  "lng": 77.5917
}
```

---

## 🎨 Design System

### Color Palette

The theme is fully dynamic — supports Light, Dark, and High Contrast modes:

| Token | Light Hex | Dark Hex | Usage |
|-------|-----------|----------|-------|
| `primaryDeepTeal` | `#00796B` | `#00796B` | Brand primary, header text |
| `primaryMidTeal` | `#00897B` | `#00897B` | Buttons, nav active |
| `accentCyan` | `#00BCD4` | `#00BCD4` | CTA, focused elements |
| `surfaceDark` (bg) | `#FFFFFF` | `#0D1B2A` | App scaffold background |
| `surfaceCard` | `#F0F8F7` | `#162A3F` | Card backgrounds |
| `surfaceCardLight` | `#E0F2F1` | `#1E3A52` | Input fields |
| `borderGlow` | `#A7DCCB` | `#00897B` | Card borders |
| `successGreen` | `#27AE60` | `#27AE60` | Resolved, dos, success |
| `warningOrange` | `#F39C12` | `#F39C12` | Warnings, medium severity |
| `dangerRed` | `#E74C3C` | `#E74C3C` | High severity, don'ts |
| `infoBlue` | `#3498DB` | `#3498DB` | Info banners |

### Typography — Nunito (Google Fonts)

| Style Token | Size | Weight | Line Height |
|-------------|------|--------|-------------|
| `displayLarge` | 32px | 800 | — |
| `displayMedium` | 28px | 700 | — |
| `headlineLarge` | 22px | 700 | — |
| `headlineMedium` | 20px | 600 | — |
| `titleLarge` | 16px | 700 | — |
| `bodyLarge` | 16px | 400 | 1.5 |
| `bodyMedium` | 14px | 400 | 1.5 |
| `bodySmall` | 12px | 400 | — |
| `labelLarge` | 14px | 700 | — |

### Gradients

```dart
CivicShieldTheme.heroGradient         // #00796B → #00897B
CivicShieldTheme.premiumGradient      // #00796B → #00BCD4 → #00897B
CivicShieldTheme.saffronGradient      // #00BCD4 → #00897B
CivicShieldTheme.vibrantSaffronGradient // animated shimmer gradient
CivicShieldTheme.darkCardGradient     // subtle card surface gradient
CivicShieldTheme.severityGradient('high')   // Red gradient
CivicShieldTheme.severityGradient('medium') // Orange gradient
CivicShieldTheme.severityGradient('low')    // Green gradient
```

### Accessibility — WCAG 2.1 AA

- Text contrast ratio ≥ 4.5:1 on all surfaces
- Minimum touch target: 48×48dp on all interactive elements
- Color never used alone — always paired with text or icon
- **Senior Mode**: text scaled ×1.2 globally via `MediaQuery` override
- **High Contrast Mode**: switches to max-contrast palette (white/black base)
- Screen reader compatible widget structure

---

## 📋 Prerequisites & Environment Setup

### 1. Install Flutter SDK

```bash
# Option A — Homebrew (macOS)
brew install --cask flutter

# Option B — Manual (recommended for custom path)
git clone https://github.com/flutter/flutter.git -b stable ~/flutter

# Verify
flutter --version
# Expected: Flutter 3.x.x • Dart 3.x.x
```

### 2. Add Flutter to PATH

If Flutter is at a custom location (like this project):

```bash
# Temporary (current terminal session)
export PATH="$PATH:/Users/karthikrnair/Documents/CODING/flutter/bin"

# Permanent — add to ~/.zshrc (macOS default shell)
echo 'export PATH="$PATH:/Users/karthikrnair/Documents/CODING/flutter/bin"' >> ~/.zshrc
source ~/.zshrc
```

### 3. Verify Full Setup

```bash
flutter doctor -v
```

You need **at least one** of these targets to be ✅:

| Target | What's needed |
|--------|---------------|
| Chrome (web) | Just Chrome installed — ✅ easiest |
| Android | Android Studio + AVD or physical device |
| iOS/macOS | Xcode + Command Line Tools |

Fix any issues shown by `flutter doctor` before proceeding.

### 4. Install Xcode Command Line Tools (macOS)

```bash
xcode-select --install

# If already installed but pointing to wrong path:
sudo xcode-select --switch /Applications/Xcode.app
xcodebuild -version
```

### 5. Enable Web Support (if not already)

```bash
flutter config --enable-web
```

---

## 🔧 Installation — Step by Step

### Step 1: Clone the Repository

```bash
git clone https://github.com/your-org/civicshield.git
cd civicshield
```

### Step 2: Install Dependencies

```bash
flutter pub get
```

Expected output:
```
Resolving dependencies...
Got dependencies!
```

### Step 3: Run Code Generation (for Hive adapters)

```bash
dart run build_runner build --delete-conflicting-outputs
```

> This generates `*.g.dart` files for Hive `TypeAdapter`s. Only needed once or when models change.

### Step 4: Verify Assets Are Present

```bash
ls assets/data/
# Expected: fines.json  hotspots.json  legal_services.json  rights_cards.json  schemes.json
```

### Step 5: Verify No Analysis Errors

```bash
flutter analyze
# Expected: No issues found! (or only info-level warnings)
```

### Step 6: Generate App Icons (optional)

If you have a logo at `assets/images/app_logo.png`:

```bash
dart run flutter_launcher_icons
```

---

## ▶️ Running the App

### ✅ Quickest: Chrome (Web)

```bash
flutter run -d chrome
```

- Opens a new Chrome window automatically
- Full hot reload support
- No setup beyond Chrome being installed

### 🖥 macOS Desktop

```bash
flutter run -d macos
```

> If you get `xcodebuild not found`:
> ```bash
> sudo xcode-select --switch /Applications/Xcode.app
> ```

### 📱 Android Device

```bash
# Enable USB Debugging on phone: Settings → Developer Options → USB Debugging

# Connect via USB then verify:
flutter devices

# Run:
flutter run -d <device-id>
# or
flutter run   # auto-selects only connected device
```

### 📱 Android Emulator

```bash
# Start emulator from Android Studio or:
emulator -avd Pixel_6_API_34

# Then:
flutter run -d emulator-5554
```

### 🍎 iOS Simulator

```bash
# Open iOS Simulator:
open -a Simulator

# Run:
flutter run -d ios
```

### 🍎 Physical iOS Device

```bash
# Requires:
# 1. Apple Developer account (free or paid)
# 2. Device registered in Xcode
# 3. Code signing configured in ios/Runner.xcworkspace

flutter run -d <ios-device-id>
```

### List All Available Devices

```bash
flutter devices
```

Sample output:
```
Found 3 connected devices:
  sdk gphone64 arm64 (mobile) • emulator-5554 • android-arm64  • Android 14
  Chrome (web)                • chrome        • web-javascript  • Google Chrome 120
  macOS (desktop)             • macos         • darwin-arm64    • macOS 14.x
```

### Hot Reload & Debug Commands

While `flutter run` is active in your terminal:

| Key | Action |
|-----|--------|
| `r` | 🔥 Hot reload — inject changes, preserve state |
| `R` | Hot restart — full restart, reset state |
| `p` | Toggle widget inspector overlay |
| `o` | Switch between renderers (web) |
| `q` | Quit the app |
| `h` | Show all available commands |
| `d` | Detach — keep app running, exit terminal control |

---

## 🔌 Backend Setup (Supabase)

The app works **100% offline with mock data**. Supabase is optional — for cloud sync, auth, and real-time features.

### Option A: Skip Supabase (Recommended for MVP Demo)

The `SupabaseService` is designed to fail gracefully if not configured. Just leave the credentials blank and the app runs fully on local JSON + SharedPreferences.

### Option B: Configure Supabase

#### 1. Create a Supabase Project

1. Go to [supabase.com](https://supabase.com) → New project
2. Copy your **Project URL** and **Anon Public Key**

#### 2. Add Credentials

Create `lib/config/supabase_config.dart`:

```dart
class SupabaseConfig {
  static const String url = 'https://your-project-id.supabase.co';
  static const String anonKey = 'your-anon-key-here';
}
```

#### 3. Create Database Tables

Run in Supabase SQL Editor:

```sql
-- Incident reports table
CREATE TABLE incident_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users,
  issue_type TEXT NOT NULL,
  violation_category TEXT,
  amount_asked DECIMAL,
  amount_paid DECIMAL,
  receipt_given BOOLEAN DEFAULT false,
  location_name TEXT,
  lat DECIMAL,
  lng DECIMAL,
  notes TEXT,
  ai_summary TEXT,
  status TEXT DEFAULT 'submitted',
  is_anonymous BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Hotspots table
CREATE TABLE hotspots (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  area_name TEXT NOT NULL,
  lat DECIMAL NOT NULL,
  lng DECIMAL NOT NULL,
  issue_category TEXT,
  report_count INT DEFAULT 1,
  support_count INT DEFAULT 0,
  severity_level TEXT DEFAULT 'medium',
  days_unresolved INT DEFAULT 0,
  status TEXT DEFAULT 'active',
  description TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Row Level Security
ALTER TABLE incident_reports ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can CRUD own reports"
  ON incident_reports FOR ALL
  USING (auth.uid() = user_id OR is_anonymous = true);

ALTER TABLE hotspots ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read hotspots"
  ON hotspots FOR SELECT USING (true);
CREATE POLICY "Authenticated insert"
  ON hotspots FOR INSERT WITH CHECK (auth.role() = 'authenticated');
```

#### 4. Enable Auth (Optional)

In Supabase Dashboard → Authentication → Providers:
- Enable **Email/Password** for named reporting
- Enable **Anonymous** sign-in for privacy-first flow

---

## 📦 Building for Production

### Android — Debug APK (Sideload / Test)

```bash
flutter build apk --debug
```
Output: `build/app/outputs/flutter-apk/app-debug.apk`

Install on device:
```bash
adb install build/app/outputs/flutter-apk/app-debug.apk
```

### Android — Release APK

1. Generate a keystore:
```bash
keytool -genkey -v -keystore ~/civicshield-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias civicshield
```

2. Create `android/key.properties`:
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=civicshield
storeFile=/Users/yourname/civicshield-release-key.jks
```

3. Build:
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android — App Bundle (Google Play Store)

```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS — Release Build

```bash
flutter build ios --release
```

Then in Xcode:
1. Open `ios/Runner.xcworkspace`
2. Set team/signing in Runner → Signing & Capabilities
3. Product → Archive
4. Distribute App → App Store Connect

### Web — Static Build

```bash
flutter build web --release --web-renderer canvaskit
```
Output: `build/web/`

Deploy to any static host:
```bash
# Netlify
netlify deploy --dir=build/web --prod

# Firebase Hosting
firebase init hosting    # set public dir to build/web
firebase deploy

# Vercel
vercel build/web --prod
```

### macOS — App Bundle

```bash
flutter build macos --release
```
Output: `build/macos/Build/Products/Release/civicshield.app`

---

## 🔥 Troubleshooting

### `No supported devices connected`

```bash
# Check what's available:
flutter devices

# Enable web if not shown:
flutter config --enable-web

# Then run on Chrome:
flutter run -d chrome
```

### `xcrun: error: unable to find utility xcodebuild`

```bash
sudo xcode-select --switch /Applications/Xcode.app
xcodebuild -version
```

### `unable to locate asset entry in pubspec.yaml`

Check that all files listed under `assets:` in `pubspec.yaml` actually exist:
```bash
ls assets/data/
ls assets/images/
```

Then re-run:
```bash
flutter pub get
flutter run -d chrome
```

### `flutter pub get` fails — dependency conflict

```bash
flutter pub upgrade
# or pin a specific version in pubspec.yaml and run pub get again
```

### Google Fonts not loading (web/offline)

Google Fonts requires internet on first load. For offline-first use, add fonts to `assets/fonts/` and declare them in `pubspec.yaml`:

```yaml
fonts:
  - family: Nunito
    fonts:
      - asset: assets/fonts/Nunito-Regular.ttf
      - asset: assets/fonts/Nunito-Bold.ttf
        weight: 700
```

### Hive box not opening

```bash
# Clean and rebuild:
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d chrome
```

### `SharedPreferences` not persisting (web)

Web SharedPreferences uses `localStorage`. Clear browser cache if seeing stale values:
Chrome → DevTools → Application → Storage → Clear Site Data

---

## 🗺 Roadmap

### ✅ Phase 1 — Hackathon MVP (Complete)
- [x] Fine Checker (25 Karnataka violations)
- [x] Know Your Rights (8 scenario cards)
- [x] Report Misuse Assistant (6-step + AI summary)
- [x] Community Hotspot Map (list + simulated map)
- [x] Evidence Vault (local persistence)
- [x] Government Schemes (12 schemes)
- [x] Analytics Dashboard
- [x] Authority Directory
- [x] Legal Services directory
- [x] Settings — Dark/Senior/HighContrast/Language
- [x] Web + macOS platform support
- [x] Supabase integration (optional)

### 🔄 Phase 2 — Beta (Month 1–2)
- [ ] Supabase cloud sync for reports (real-time)
- [ ] Firebase push notifications (escalation Day 7/14/30)
- [ ] Real flutter_map + OpenStreetMap tiles
- [ ] PDF export for complaint letter
- [ ] Full translation — Hindi, Kannada, Tamil, Telugu, Marathi
- [ ] Onboarding flow (3-screen walkthrough)
- [ ] Offline map tile caching

### 🚀 Phase 3 — Public Launch (Month 3–4)
- [ ] Lawyer Connect directory (NALSA empanelled)
- [ ] In-app RTI filing assistant
- [ ] On-device AI image analysis (evidence classification)
- [ ] Community civic news feed
- [ ] Consumer rights module expansion

### 📈 Phase 4 — Scale (Month 5–12)
- [ ] Multi-state fine database (10 states)
- [ ] Official API integrations (PM-KISAN, Ayushman, etc.)
- [ ] Lawyer video consultation
- [ ] Wearable companion (watchOS / Wear OS)
- [ ] Open civic data API for NGOs and researchers

---

## 🤝 Contributing

### Getting Started

```bash
git fork https://github.com/your-org/civicshield
git clone https://github.com/YOUR_USERNAME/civicshield
cd civicshield
git checkout -b feature/your-feature-name
```

### Adding a New Feature

1. **Screen** → `lib/screens/feature_name/feature_name_screen.dart`
2. **Model** → `lib/models/feature_name_model.dart`
3. **Provider** → `lib/providers/feature_name_provider.dart`
4. **Route** → Register in `lib/app/router.dart`
5. **Widgets** → Use existing components from `lib/widgets/`
6. **Theme** → Use `CivicShieldTheme.*` constants only

### Code Standards

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart/style)
- Use `const` constructors wherever possible
- All providers use `AsyncValue` for loading/error states
- Descriptive names: `buildFineCard()` not `buildCard()`
- Run `flutter analyze` — must show **0 errors** before PR

### Commit Message Format

```
feat: add authority directory search filter
fix: correct fine amount for drunk driving repeat offense
docs: update roadmap Phase 2
refactor: extract severity badge to shared widget
```

### Pull Request Process

1. Ensure `flutter analyze` passes
2. Test on at least Chrome + one mobile emulator
3. Update `README.md` if you add a screen or change setup steps
4. Tag PR with appropriate labels: `feature`, `fix`, `docs`, `refactor`

---

## ⚖️ Legal Disclaimers

> **Fine amounts are indicative based on the latest available official notifications. Always verify with the official challan issued by the enforcement officer.**

> **This application provides civic awareness and legal guidance for educational purposes only. It is NOT a substitute for qualified legal advice.**

> **CivicShield does not guarantee government department action on any complaint submitted through or inspired by this application.**

> **The app must not be used to encourage or facilitate confrontation with public officials. Always remain calm, note details safely, and use proper statutory complaint channels.**

> **All fee and engagement arrangements with lawyers accessed through the app are solely between the user and the lawyer. CivicShield is not a party to any such arrangement.**

### Key Legal References

| Legislation | Relevance |
|-------------|-----------|
| Motor Vehicles (Amendment) Act, 2019 | Traffic penalty amounts and structure |
| Right to Information Act, 2005 | RTI application rights and process |
| Legal Services Authorities Act, 1987 | Entitlement to free legal aid via NALSA |
| Consumer Protection Act, 2019 | Consumer rights and dispute resolution |
| Information Technology Act, 2000 | Digital evidence admissibility |
| Prevention of Corruption Act, 1988 | Bribery and misconduct legal provisions |
| Code of Criminal Procedure, 1973 | FIR rights, police complaint procedure |
| Karnataka Motor Vehicles Rules, 1963 | Karnataka-specific enforcement rules |

### Emergency & Civic Contacts

| Service | Contact |
|---------|---------|
| Police Emergency | **100** |
| Women's Helpline | **1091** |
| Unified Emergency | **112** |
| NALSA Legal Aid | **15100** |
| Anti-Corruption Bureau (KA) | **1064** / acb.karnataka.gov.in |
| National Consumer Helpline | **1800-11-4000** |
| RTI Online Portal | rtionline.gov.in |
| e-Challan Payment | parivahan.gov.in |

---

## 📄 License

```
MIT License

Copyright (c) 2026 CivicShield

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
```

---

<div align="center">

**Built with ❤️ for civic empowerment in India**

*CivicShield v1.0 · Flutter Hackathon MVP · April 2026*

**Know Your Rights. Verify Enforcement. Strengthen Accountability.**

<br/>

[![SDG 9](https://img.shields.io/badge/SDG%209-Industry%20%26%20Innovation-F39C12)](https://sdgs.un.org/goals/goal9)
[![SDG 16](https://img.shields.io/badge/SDG%2016-Peace%20%26%20Justice-3498DB)](https://sdgs.un.org/goals/goal16)

</div>
