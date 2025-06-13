
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:gastrorate/store/auth/auth_state.dart';
import 'package:gastrorate/store/places/places_state.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_state.g.dart';

@CopyWith()
@JsonSerializable()
class AppState{
  final PlacesState placesState;
  final AuthState authState;

  static Future<AppState> init() async {
    final auth = await AuthState.init();
    final places = PlacesState.init(); // assuming this is synchronous

    return AppState(
      authState: auth,
      placesState: places,
    );
  }

  factory AppState.fromJson(Map<String, dynamic> json) => _$AppStateFromJson(json);

  Map<String, dynamic> toJson() => _$AppStateToJson(this);

//<editor-fold desc="Data Methods">
  const AppState({
    required this.placesState,
    required this.authState,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppState &&
          runtimeType == other.runtimeType &&
          placesState == other.placesState &&
          authState == other.authState);

  @override
  int get hashCode => placesState.hashCode ^ authState.hashCode;

  @override
  String toString() {
    return 'AppState{' + ' placesState: $placesState,' + ' authState: $authState,' + '}';
  }

  AppState copyWith({
    PlacesState? placesState,
    AuthState? authState,
  }) {
    if ((placesState == null || identical(placesState, this.placesState)) &&
        (authState == null || identical(authState, this.authState))) {
      return this;
    }

    return AppState(
      placesState: placesState ?? this.placesState,
      authState: authState ?? this.authState,
    );
  }

  Map<String, dynamic> toMap({
    String Function(String key)? keyMapper,
  }) {
    keyMapper ??= (key) => key;

    return {
      keyMapper('placesState'): this.placesState,
      keyMapper('authState'): this.authState,
    };
  }

  factory AppState.fromMap(
    Map<String, dynamic> map, {
    String Function(String key)? keyMapper,
  }) {
    keyMapper ??= (key) => key;

    return AppState(
      placesState: map[keyMapper('placesState')] as PlacesState,
      authState: map[keyMapper('authState')] as AuthState,
    );
  }

//</editor-fold>
}