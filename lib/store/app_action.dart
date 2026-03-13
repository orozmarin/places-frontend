import 'package:async_redux/async_redux.dart';
import 'package:gastrorate/store/app_state.dart';

/// Marker base class for async Redux actions that involve API calls.
/// Extend this instead of [ReduxAction<AppState>] for actions that call the backend.
///
/// Loading state is tracked automatically by async_redux via [VmFactory.isWaiting].
/// In any VmFactory.fromStore(), check: `isWaiting(YourAction)`
abstract class AppAction extends ReduxAction<AppState> {}
