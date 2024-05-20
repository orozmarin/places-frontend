
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:gastrorate/store/places/places_state.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_state.g.dart';

@CopyWith()
@JsonSerializable()
class AppState{
  final PlacesState placesState;

  AppState.init()
  : placesState = PlacesState.init();

  factory AppState.fromJson(Map<String, dynamic> json) => _$AppStateFromJson(json);

  Map<String, dynamic> toJson() => _$AppStateToJson(this);

//<editor-fold desc="Data Methods">
  const AppState({
    required this.placesState,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppState && runtimeType == other.runtimeType && placesState == other.placesState);

  @override
  int get hashCode => placesState.hashCode;

  @override
  String toString() {
    return 'AppState{ placesState: $placesState,}';
  }

  AppState copyWith({
    PlacesState? placesState,
  }) {
    return AppState(
      placesState: placesState ?? this.placesState,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'placesState': this.placesState,
    };
  }

  factory AppState.fromMap(Map<String, dynamic> map) {
    return AppState(
      placesState: map['placesState'] as PlacesState,
    );
  }

//</editor-fold>
}