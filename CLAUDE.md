# Places Frontend

A Flutter app for saving, discovering, and reviewing restaurants/places. Users can manage personal place lists, rate locations, and discover nearby restaurants via Google Places.

## Tech Stack

- **Flutter** 3.32.0 (managed via FVM — use `fvm flutter` or configure FVM globally)
- **Dart** >=3.1.0
- **State:** `async_redux` — Redux with async action support
- **Navigation:** `go_router` — Declarative routing with auth guards
- **HTTP:** `dio` with JWT interceptor
- **Serialization:** `json_serializable` + `copy_with_extension` (code generation)
- **Storage:** `shared_preferences` for token/user persistence
- **Config:** `flutter_dotenv` — `.env` file for API keys

## Key Directories

| Path | Purpose |
|------|---------|
| `lib/models/` | Immutable data models (JSON-serializable, copyWith) |
| `lib/store/` | Redux state — `AppState`, actions, reducers |
| `lib/screens/` | UI pages: `*_page.dart` = StoreConnector wrapper, companion file = UI |
| `lib/widgets/` | Reusable widgets (AppBar, navigation scaffold, cards) |
| `lib/service/` | Business logic managers (`AuthManager`, `PlaceManager`, `ApiService`) |
| `lib/http/` | Dio interceptors and token storage helpers |
| `lib/tools/` | Stateless utilities (`LocationHelper`, `ToastHelper`, `UserHelper`) |
| `lib/theme/` | `MyColors` constants and Material theme config |
| `lib/router.dart` | All route definitions and auth redirect logic |
| `lib/store/app_state.dart` | Root Redux state composition |

## Essential Commands

```bash
# Install dependencies
flutter pub get

# Run code generation (required after model changes)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode during development
flutter pub run build_runner watch --delete-conflicting-outputs

# Run app (Android emulator — backend expects localhost at 10.0.2.2)
flutter run

# Run tests
flutter test

# Analyze
flutter analyze
```

> **Note:** The backend base URL is hardcoded as `http://10.0.2.2:8080/rest` (Android emulator localhost). Update `lib/service/api_service.dart` for other targets.

## Related Projects

| Project | Path |
|---------|------|
| Backend (Spring Boot 3 + MongoDB) | `/Users/marinoroz/Documents/OrozDigital/places-backend/` |

When a task involves both frontend and backend changes (e.g., new API endpoint + consuming it in Flutter), read and edit files in both projects freely.

## Additional Documentation

Check these files when working on related tasks:

- `.claude/docs/architectural_patterns.md` — Redux action lifecycle, Page/Screen split, ViewModel factory, Manager pattern, router guards
