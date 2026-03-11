# Architectural Patterns

## 1. Page / Screen Split (Redux Connection)

Every route has two files:
- `*_page.dart` — `StoreConnector` wrapper that reads state and creates a `ViewModel`
- Companion file (e.g., `home.dart`) — pure UI `StatefulWidget` / `StatelessWidget` that receives data and callbacks

The page file never contains UI; the screen file never touches the store directly.

**Reference:** `lib/screens/home_page.dart` + `lib/screens/home.dart`

---

## 2. Redux Action Lifecycle (async_redux)

Actions extend `ReduxAction<AppState>` and use three optional lifecycle hooks:

```
before()  →  reduce()  →  after()
```

- `before()`: Pre-dispatch side effects (e.g., show loading)
- `reduce()`: Returns new `AppState` (the only place state mutates)
- `after()`: Post-dispatch cleanup (e.g., hide loading)

Actions may `dispatch()` other actions from within `reduce()` or `after()`.

**Reference:** `lib/store/places/places_actions.dart`, `lib/store/auth/auth.actions.dart`

---

## 3. ViewModel Factory Pattern

Each `*_page.dart` defines a `ViewModel` class and a `VmFactory`:

- `ViewModel` holds the subset of state the screen needs + callbacks as `Function` fields
- `VmFactory.fromStore()` maps `AppState` → `ViewModel`
- `ViewModel` overrides `==` / `hashCode` so the screen only rebuilds on relevant changes

**Reference:** `lib/screens/places_page.dart`, `lib/screens/home_page.dart`

---

## 4. Manager Pattern (Service Layer)

Business logic lives in manager singletons under `lib/service/`:

- `ApiService` — configures a shared `Dio` instance with `AuthInterceptor`
- `AuthManager` — wraps auth endpoints (login, register, logout)
- `PlaceManager` — wraps place CRUD endpoints

Managers own the try/catch boundary and convert raw JSON to model objects. Actions call managers; managers call `ApiService`.

**Reference:** `lib/service/api_service.dart`, `lib/service/place_manager.dart`, `lib/service/auth_manager.dart`

---

## 5. JWT Auth Interceptor

`AuthInterceptor` (`lib/http/auth_interceptor.dart`) is a Dio interceptor that:

1. Reads the JWT token from `AuthHelper` (SharedPreferences) before every request
2. Injects `Authorization: Bearer <token>` into the request headers

A 401 response anywhere in the app dispatches `LogoutAction` to clear state.

**Reference:** `lib/http/auth_interceptor.dart`, `lib/http/auth_helper.dart`

---

## 6. Immutable State with copyWith

All state and model classes are immutable (`final` fields). Updates use generated `copyWith()`:

```dart
state.copyWith(places: newList, isLoading: false)
```

Models annotated with `@CopyWith()` and `@JsonSerializable()` have corresponding `.g.dart` generated files. Never edit `.g.dart` files manually.

**Reference:** `lib/store/places/places_state.dart`, `lib/models/place.dart`

---

## 7. Stateful Shell Navigation (GoRouter)

The app uses `StatefulShellRoute` with 4 branches (Home, Places, Favorites, Profile). Each branch has its own `NavigatorKey`, preserving scroll/state independently.

`ScaffoldWithNestedNavigation` renders:
- `BottomNavigationBar` when screen width < 450px
- `NavigationRail` when screen width >= 450px

Auth redirect: if no user in `AuthHelper`, GoRouter redirects every route to `/login`.

**Reference:** `lib/router.dart`, `lib/widgets/scaffold_nested_navigation.dart`

---

## 8. Helpers as Stateless Utilities

`lib/tools/` contains stateless singleton-style helpers with only static or instance methods — no state, no side effects beyond their domain:

- `LocationHelper` — geolocator permission + current position
- `ToastHelper` — typed toast notifications (success / error / info)
- `UserHelper` — user display utilities

These are called directly from actions or widgets; they do not interact with the Redux store.

**Reference:** `lib/tools/location_helper.dart`, `lib/tools/toast_helper.dart`
