// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AppStateCWProxy {
  AppState placesState(PlacesState placesState);

  AppState authState(AuthState authState);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `AppState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AppState(...).copyWith(id: 12, name: "My name")
  /// ```
  AppState call({PlacesState placesState, AuthState authState});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfAppState.copyWith(...)` or call `instanceOfAppState.copyWith.fieldName(value)` for a single field.
class _$AppStateCWProxyImpl implements _$AppStateCWProxy {
  const _$AppStateCWProxyImpl(this._value);

  final AppState _value;

  @override
  AppState placesState(PlacesState placesState) =>
      call(placesState: placesState);

  @override
  AppState authState(AuthState authState) => call(authState: authState);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `AppState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AppState(...).copyWith(id: 12, name: "My name")
  /// ```
  AppState call({
    Object? placesState = const $CopyWithPlaceholder(),
    Object? authState = const $CopyWithPlaceholder(),
  }) {
    return AppState(
      placesState:
          placesState == const $CopyWithPlaceholder() || placesState == null
              ? _value.placesState
              // ignore: cast_nullable_to_non_nullable
              : placesState as PlacesState,
      authState:
          authState == const $CopyWithPlaceholder() || authState == null
              ? _value.authState
              // ignore: cast_nullable_to_non_nullable
              : authState as AuthState,
    );
  }
}

extension $AppStateCopyWith on AppState {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfAppState.copyWith(...)` or `instanceOfAppState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AppStateCWProxy get copyWith => _$AppStateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppState _$AppStateFromJson(Map<String, dynamic> json) => AppState(
  placesState: PlacesState.fromJson(
    json['placesState'] as Map<String, dynamic>,
  ),
  authState: AuthState.fromJson(json['authState'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AppStateToJson(AppState instance) => <String, dynamic>{
  'placesState': instance.placesState,
  'authState': instance.authState,
};
