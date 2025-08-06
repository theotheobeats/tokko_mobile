# CRUSH

Project: Flutter (Dart) mobile app with go_router, Riverpod, Dio, secure storage, shared_preferences.

Build / Run
- Setup: flutter pub get
- Analyze (lints/types): flutter analyze
- Format: dart format .
- Run app (auto device): flutter run
- iOS simulator quickstart: open -a Simulator && flutter run -d ios
- Clean builds: flutter clean && (cd ios && pod install) || true

Test
- All tests: flutter test
- Single file: flutter test test/path/to_test.dart
- Single test (name): flutter test --name "partial test name"
- Coverage: flutter test --coverage && genhtml coverage/lcov.info -o coverage/html

Linting & Style
- Lints: analysis_options.yaml includes package:flutter_lints/flutter.yaml; use flutter analyze to check.
- Formatting: enforce dart format with 80 cols default; prefer single quotes where reasonable.
- Imports: package imports before relative; export public APIs from barrel files only if already present; avoid unused imports.
- Types: prefer explicit types for public APIs; allow var for locals with obvious initializer; avoid dynamic, use typed Riverpod providers.
- Null-safety: avoid nullable unless needed; use required and default values; guard async/await with try/catch.
- Naming: UpperCamelCase for classes/types; lowerCamelCase for vars, functions; SCREAMING_SNAKE_CASE for consts; files use snake_case.dart.
- Widgets: keep build methods pure; extract widgets > ~100 lines; favor const constructors; avoid setState with Riverpod state.
- Errors: never print; use FlutterError.reportError or structured logging; map Dio errors to domain errors; no secrets in logs.
- Networking: centralize Dio config (timeouts/interceptors); handle connectivity_plus for offline UX before network calls.
- State: prefer immutable state; provide providers at top-level; dispose resources via ref.onDispose.

CI/local checklist
- Run: flutter pub get && flutter analyze && dart format --set-exit-if-changed . && flutter test
- iOS pods: if iOS build fails, run: cd ios && pod repo update && pod install && cd ..

Notes
- No Cursor/Copilot rules found.
