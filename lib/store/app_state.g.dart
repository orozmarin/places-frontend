// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AppStateCWProxy {
  AppState placesState(PlacesState placesState);

  AppState authState(AuthState authState);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AppState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AppState(...).copyWith(id: 12, name: "My name")
  /// ````
  AppState call({
    PlacesState? placesState,
    AuthState? authState,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAppState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAppState.copyWith.fieldName(...)`
class _$AppStateCWProxyImpl implements _$AppStateCWProxy {
  const _$AppStateCWProxyImpl(this._value);

  final AppState _value;

  @override
  AppState placesState(PlacesState placesState) =>
      this(placesState: placesState);

  @override
  AppState authState(AuthState authState) => this(authState: authState);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AppState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AppState(...).copyWith(id: 12, name: "My name")
  /// ````
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
      authState: authState == const $CopyWithPlaceholder() || authState == null
          ? _value.authState
          // ignore: cast_nullable_to_non_nullable
          : authState as AuthState,
    );
  }
}

extension $AppStateCopyWith on AppState {
  /// Returns a callable class that can be used as follows: `instanceOfAppState.copyWith(...)` or like so:`instanceOfAppState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AppStateCWProxy get copyWith => _$AppStateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppState _$AppStateFromJson(Map<String, dynamic> json) => AppState(
      placesState:
          PlacesState.fromJson(json['placesState'] as Map<String, dynamic>),
      authState: AuthState.fromJson(json['authState'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppStateToJson(AppState instance) => <String, dynamic>{
      'placesState': instance.placesState,
      'authState': instance.authState,
    };
