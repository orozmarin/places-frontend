import 'package:gastrorate/models/restaurant.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurants_state.g.dart';

@JsonSerializable(explicitToJson: true)
class RestaurantsState{
  List<Restaurant>? restaurants;
  Restaurant? currentRestaurant;

//<editor-fold desc="Data Methods">
  RestaurantsState({
    this.restaurants,
    this.currentRestaurant,
  });

  RestaurantsState.init(){
    this.restaurants = List<Restaurant>.empty();
  }

  factory RestaurantsState.fromJson(Map<String, dynamic> json) => _$RestaurantsStateFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantsStateToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RestaurantsState &&
          runtimeType == other.runtimeType &&
          restaurants == other.restaurants &&
          currentRestaurant == other.currentRestaurant);

  @override
  int get hashCode => restaurants.hashCode ^ currentRestaurant.hashCode;

  @override
  String toString() {
    return 'RestaurantsState{' + ' restaurants: $restaurants,' + ' currentRestaurant: $currentRestaurant,' + '}';
  }

  RestaurantsState copyWith({
    List<Restaurant>? restaurants,
    Restaurant? currentRestaurant,
  }) {
    return RestaurantsState(
      restaurants: restaurants ?? this.restaurants,
      currentRestaurant: currentRestaurant ?? this.currentRestaurant,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurants': this.restaurants,
      'currentRestaurant': this.currentRestaurant,
    };
  }

  factory RestaurantsState.fromMap(Map<String, dynamic> map) {
    return RestaurantsState(
      restaurants: map['restaurants'] as List<Restaurant>,
      currentRestaurant: map['currentRestaurant'] as Restaurant,
    );
  }

//</editor-fold>
}