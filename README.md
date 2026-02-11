# Hue Messenger (Phase A)

Hue is an intent-first messenger prototype built with Flutter for iOS-first UX validation.

## Scope
- 1:1 chat only
- Normal text messages
- Hue messages (Red, Yellow, Green, Blue)
- Local mock data only (no backend in Phase A)
- Hue Box as default home tab

## Current Status
Implemented so far:
- App entry + Riverpod setup
- Theme tokens + light/dark theme
- Core models
- In-memory mock repository + seed data
- Tab shell: Hue Box, Chats, Settings
- Hue Box filter + sorting + swipe/long-press `Got it`
- Unit tests for Hue Box sorting rules
- Chats to Chat Detail navigation + new chat sheet
- Normal message send flow in Chat Detail
- Hue sheet + template-based Hue send flow
- Premium Hue sheet redesign (larger touch targets, category chips, better visual hierarchy)
- Rate limit service + blocked Hue send dialog with retry wait
- Templates management: add/edit/delete custom templates (max 10/category, no emoji)
- Rate limits settings screen wired to local logic
- Cross-screen sync via repository revision stream
- 3 visual theme presets: `Minimal`, `Glassy`, `High Contrast`

## Run
1. `flutter pub get`
2. `flutter run -d chrome`

Notes:
- Windows desktop run/build needs Visual Studio with `Desktop development with C++`.
- Web and Windows platform folders are configured in this repository.

## Project Layout
- `lib/app`: app shell, routing, theme
- `lib/core`: models and mock repository
- `lib/features`: feature screens/controllers
- `docs`: product and sprint specs
