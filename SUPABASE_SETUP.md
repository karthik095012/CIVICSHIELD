# Supabase Integration Guide

CivicShield has **Supabase dependencies installed** and config files ready for backend integration. Currently, the app uses **local authentication** as default with Supabase as an optional backend.

## Current Status

✅ **Local Auth Working** - App fully functional with local device storage  
✅ **Supabase Packages Added** - supabase_flutter dependency installed  
✅ **Config Structure Ready** - Placeholder configuration file in place  
⏳ **Backend Integration** - Can be implemented by users or in future updates  

## Quick Setup (5 minutes)

If you want to enable Supabase backend:

### 1. Create Supabase Project
- Go to [https://app.supabase.com](https://app.supabase.com)
- Create a new project
- Note your **Project URL** and **Anon Key**

### 2. Update Configuration
Edit `lib/config/supabase_config.dart`:

```dart
class SupabaseConfig {
  static const String url = 'https://your-project.supabase.co';
  static const String anonKey = 'your_anon_key_here';
}
```

### 3. Create Database Tables

In Supabase SQL Editor, run:

```sql
-- User Profiles
CREATE TABLE user_profiles (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Incident Reports
CREATE TABLE incident_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES user_profiles(id),
  issue_type TEXT,
  violation_category TEXT,
  amount_asked DECIMAL,
  amount_paid DECIMAL,
  receipt_given BOOLEAN,
  location_name TEXT,
  notes TEXT,
  status TEXT DEFAULT 'saved',
  created_at TIMESTAMP DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE incident_reports ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users see own profile" ON user_profiles 
  FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users create reports" ON incident_reports 
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users view own reports" ON incident_reports 
  FOR SELECT USING (auth.uid() = user_id);
```

### 4. Initialize Supabase in main.dart

Currently commented out. Uncomment to enable:

```dart
// lib/main.dart
if (SupabaseConfig.isConfigured()) {
  await SupabaseService().initialize(
    supabaseUrl: SupabaseConfig.url,
    supabaseKey: SupabaseConfig.anonKey,
  );
}
```

Then update auth_provider.dart to use SupabaseAuthService.

## Architecture

```
CivicShield
├── Local Auth (Current - Always Works)
│   ├── SharedPreferences for storage
│   └── json_encode/decode for user data
│
├── Supabase Services (Infrastructure Ready)
│   ├── lib/services/supabase_service.dart (DB + Auth wrapper)
│   ├── lib/services/supabase_auth_service.dart (Auth logic)
│   ├── lib/config/supabase_config.dart (Credentials)
│   └── pubspec.yaml (supabase_flutter ^2.4.0)
│
└── Optional Backend Integration
    └── Can be enabled when needed
```

## Features Available

### Now (Local Auth)
- Email/Phone login and signup
- User profiles stored locally
- Reports saved to device
- Works offline ✓
- Test accounts easily ✓
- No backend needed ✓

### With Supabase (When Enabled)
- Cloud-backed user profiles
- Synced incident reports
- User preferences storage
- Multi-device sync
- Cloud backup
- Real-time updates (optional)

## File Locations

| File | Purpose |
|------|---------|
| `lib/config/supabase_config.dart` | Credentials (update this) |
| `lib/services/supabase_service.dart` | Database + Auth API wrapper |
| `lib/services/supabase_auth_service.dart` | Auth logic for Supabase |
| `lib/main.dart` | Uncomment initialization |
| `lib/providers/auth_provider.dart` | Switch to SupabaseAuthService |
| `SUPABASE_SETUP.md` | This file |

## Testing

### Test with Local Auth (Default)
```bash
flutter run
# Signup: Test User, 1234567890, test@example.com, Password123
# Login with same credentials
# Works offline ✓
```

### Test with Supabase (After Setup)
```bash
# Configure credentials in supabase_config.dart
# Uncomment Supabase init in main.dart
# Check Supabase dashboard for synced data
```

## Next Steps for Full Supabase Integration

1. **Enable Supabase in main.dart** - Uncomment initialization
2. **Update auth_provider.dart** - Use SupabaseAuthService for auth
3. **Wire Reports to Cloud** - Store incident reports in Supabase
4. **Add Real-time Sync** - Update reports list automatically
5. **User Preferences** - Store settings in cloud

## Troubleshooting

### "Configuration not set" message
- Update `lib/config/supabase_config.dart` with your credentials

### Connection errors
- Check internet connection
- Verify Supabase project is active
- Check credentials in config file

### RLS policy errors
- Make sure policies are created correctly in Supabase
- Users can only see their own data by design

## Support

For Supabase documentation: https://supabase.com/docs  
For Flutter Supabase: https://github.com/supabase/supabase-flutter

---

**Note**: The app works perfectly with local auth. Supabase integration is **optional** and can be enabled whenever you're ready for a cloud backend!

