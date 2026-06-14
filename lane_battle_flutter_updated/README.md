# Lane Battle (Flutter + Flame) - Updated

This ZIP contains only the Dart source (`lib/`) + `pubspec.yaml`.

## How to run (recommended)
1. Create a new Flutter app (once):
   - `flutter create lane_battle_app`
2. Copy this ZIP contents into that project (merge):
   - replace `lib/` folder
   - merge `pubspec.yaml` dependency: add `flame: ^1.18.0`
3. Run:
   - `flutter pub get`
   - `flutter run`

## Updates included
- Fixes common Dart compile issues (Vector2 imports, clamp casts)
- Start screen (Play)
- Victory and Defeat screens
- Coin + P reward FX after enemy dies (1 second)
- Pause / Resume / Retry (+ Home)
- Faster P regeneration (0.5s per +1P)

