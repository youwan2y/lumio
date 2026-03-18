# Repository Guidelines

## Project Structure & Module Organization
`lib/` contains the application code. Keep app entry in `lib/main.dart`, shared configuration in `lib/config/`, state in `lib/providers/`, API and storage logic in `lib/services/`, screens in `lib/screens/`, reusable UI in `lib/widgets/`, and domain models in `lib/models/`. Tests live in `test/` and currently use Flutter widget tests. Static assets are under `assets/icons/` and must also be declared in `pubspec.yaml`. Platform folders (`android/`, `ios/`, `macos/`, `web/`, `windows/`, `linux/`) should only be edited for platform-specific configuration.

## Build, Test, and Development Commands
Run `flutter pub get` after changing dependencies. Use `flutter run -d macos`, `flutter run -d ios`, or `flutter run -d chrome` for local development. `./start.sh` is a convenience wrapper for macOS by default, or `./start.sh ios` / `./start.sh web`. Run `flutter analyze` before opening a PR to enforce lint rules, and `dart format lib test` to normalize formatting. Use `flutter test` for the full test suite.

## Coding Style & Naming Conventions
Follow Flutter defaults: 2-space indentation, trailing commas where formatter applies them, and `flutter_lints` from `analysis_options.yaml`. Use `UpperCamelCase` for classes and widgets, `lowerCamelCase` for methods and fields, and `snake_case.dart` for file names such as `question_screen.dart`. Keep widgets focused and move cross-screen logic into providers or services instead of growing screen files.

## Testing Guidelines
Use `flutter_test` for widget and unit coverage. Name test files with the `_test.dart` suffix and keep the subject clear, for example `app_state_test.dart` or `question_screen_test.dart`. Add or update tests when changing navigation, provider state, or generation flows. Verify locally with `flutter test`.

## Commit & Pull Request Guidelines
Recent commits use short imperative subjects such as `fix` and `Add photo album permission configuration`; prefer the more descriptive form. Keep commit titles concise, imperative, and scoped to one change. PRs should include a short summary, linked issue if applicable, platforms tested, and screenshots or recordings for UI changes.

## Security & Configuration Tips
Do not commit real API keys. Keep secrets in local config only and update `lib/config/api_config.dart` with placeholders or environment-specific values before sharing branches.
