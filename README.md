# Poqo

**The pocket companion for a calmer, better you. One small step daily.**

Poqo is a sleek, minimalist mobile app (iOS & Android) for daily micro-habits and mindful routines. Built with Flutter for a native cross-platform experience.

## Features

### Free Tier
- Track up to **3 habits** daily with categories (Morning, Focus, Health, Learning, Evening, Custom)
- **Mood checker** with emoji selection, notes, and tags
- **Daily reflection prompts** to encourage mindfulness
- **7-day stats overview** with habit completion heatmap and mood trends
- Offline-first with local storage
- Light and dark theme

### Premium ($5/month or $49/year)
- **Unlimited habits** and custom categories
- **Advanced analytics**: weekly/monthly heatmaps, correlation insights
- **Premium reflection prompts** for deeper self-awareness
- **Data export** (JSON)
- 14-day free trial available

## Architecture

### Tech Stack
- **Framework**: Flutter 3.x (Dart)
- **State Management**: Riverpod (StateNotifier + Provider pattern)
- **Local Storage**: SharedPreferences (JSON serialization)
- **Typography**: Google Fonts (Nunito)
- **Animations**: flutter_animate

### Project Structure

```
lib/
├── main.dart                 # App entry point, ProviderScope setup
├── models/
│   ├── habit.dart            # Habit & HabitCompletion models
│   ├── mood_entry.dart       # MoodEntry & MoodLevel enum
│   ├── reflection.dart       # Reflection model & default prompts
│   └── user_profile.dart     # UserProfile & SubscriptionTier
├── providers/
│   ├── storage_provider.dart # SharedPreferences & StorageService providers
│   ├── user_provider.dart    # User profile & subscription state
│   ├── habit_provider.dart   # Habit list, completions, streaks, progress
│   ├── mood_provider.dart    # Mood entries, today's mood, weekly average
│   └── reflection_provider.dart # Reflections & daily prompt rotation
├── screens/
│   ├── main_shell.dart       # Bottom navigation shell with quick-log action
│   ├── home_screen.dart      # Dashboard: progress ring, habits, mood, reflection
│   ├── add_habit_screen.dart # Create/edit habit with category picker
│   ├── mood_screen.dart      # Mood logging with emoji selector and tags
│   ├── reflection_screen.dart # Daily prompt & past reflections journal
│   ├── stats_screen.dart     # 7-day analytics: completions, mood chart, heatmap
│   └── settings_screen.dart  # Theme, subscription, reminders, data export
├── services/
│   └── storage_service.dart  # CRUD operations via SharedPreferences
├── theme/
│   └── app_theme.dart        # Light/dark themes, PoqoColors palette
├── utils/
│   └── date_utils.dart       # DateTime extensions for display formatting
└── widgets/
    ├── habit_tile.dart       # Tappable habit row with completion + streak
    ├── mood_selector.dart    # Emoji mood picker (5 levels)
    ├── premium_badge.dart    # PRO badge & premium gate overlay
    ├── progress_ring.dart    # Animated circular progress indicator
    └── section_header.dart   # Reusable section title with action
```

### Data Flow
1. **StorageService** wraps SharedPreferences for JSON-based persistence
2. **Riverpod providers** load data from storage on init, write back on mutations
3. **UI screens** watch providers and rebuild reactively
4. **Freemium gating** checks `UserProfile.hasAccess` to enforce limits

## Getting Started

### Prerequisites
- Flutter SDK 3.11+
- Dart SDK 3.11+

### Setup
```bash
flutter pub get
flutter run
```

### Running Tests
```bash
flutter test
```

### Building for Production
```bash
flutter build apk --release    # Android
flutter build ios --release     # iOS (requires macOS + Xcode)
```

## Subscription Model

| Plan | Price | Features |
|------|-------|----------|
| Free | $0 | 3 habits, basic mood/reflection, 7-day stats |
| Monthly | $5/month | Unlimited habits, premium prompts, advanced analytics |
| Yearly | $49/year | Same as monthly (save ~18%) |
| Lifetime | $99 one-time | Permanent premium access |

The app includes a subscription management scaffold ready for RevenueCat integration.

## Design Philosophy

- **Ultra-minimalist**: Clean UI with calm, neutral aesthetics (Calm meets Streaks)
- **Reflection over streaks**: Focus on sustainable change, not perfection
- **Privacy-first**: Local-first storage, no ads, no data selling
- **30-60 second daily usage**: Quick check-ins that build lasting habits

## Roadmap (v2)

- [ ] AI-powered smart suggestions via OpenAI/Grok API
- [ ] Guided audio reflections (1-3 min mindfulness)
- [ ] Apple Watch / Wear OS complications
- [ ] Home screen widgets for quick check-ins
- [ ] Supabase/Firebase backend for cross-device sync
- [ ] RevenueCat subscription integration
- [ ] Weekly/monthly correlation insights (Premium)

## License

Proprietary. All rights reserved.
