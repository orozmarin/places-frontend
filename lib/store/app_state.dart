
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:gastrorate/store/restaurants/restaurants_state.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_state.g.dart';

@CopyWith()
@JsonSerializable()
class AppState{
  final RestaurantsState restaurantsState;

  AppState.init()
  : restaurantsState = RestaurantsState.init();

  factory AppState.fromJson(Map<String, dynamic> json) => _$AppStateFromJson(json);

  Map<String, dynamic> toJson() => _$AppStateToJson(this);

//<editor-fold desc="Data Methods">
  const AppState({
    required this.restaurantsState,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppState && runtimeType == other.runtimeType && restaurantsState == other.restaurantsState);

  @override
  int get hashCode => restaurantsState.hashCode;

  @override
  String toString() {
    return 'AppState{ restaurantsState: $restaurantsState,}';
  }

  AppState copyWith({
    RestaurantsState? restaurantsState,
  }) {
    return AppState(
      restaurantsState: restaurantsState ?? this.restaurantsState,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'restaurantsState': this.restaurantsState,
    };
  }

  factory AppState.fromMap(Map<String, dynamic> map) {
    return AppState(
      restaurantsState: map['restaurantsState'] as RestaurantsState,
    );
  }

//</editor-fold>
}