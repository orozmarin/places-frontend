import 'package:gastrorate/models/place.dart';
import 'package:json_annotation/json_annotation.dart';

part 'places_state.g.dart';

@JsonSerializable(explicitToJson: true)
class PlacesState{
  List<Place>? places;
  List<Place>? nearbyPlaces;
  List<Place>? favoritePlaces;
  Place? place;

  PlacesState.init(){
    this.places = List<Place>.empty();
    this.nearbyPlaces = List<Place>.empty();
    this.favoritePlaces = List<Place>.empty();
  }

  factory PlacesState.fromJson(Map<String, dynamic> json) => _$PlacesStateFromJson(json);

  Map<String, dynamic> toJson() => _$PlacesStateToJson(this);

//<editor-fold desc="Data Methods">
  PlacesState({
    this.places,
    this.nearbyPlaces,
    this.favoritePlaces,
    this.place,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlacesState &&
          runtimeType == other.runtimeType &&
          places == other.places &&
          nearbyPlaces == other.nearbyPlaces &&
          favoritePlaces == other.favoritePlaces &&
          place == other.place);

  @override
  int get hashCode => places.hashCode ^ nearbyPlaces.hashCode ^ favoritePlaces.hashCode ^ place.hashCode;

  @override
  String toString() {
    return 'PlacesState{' +
        ' places: $places,' +
        ' nearbyPlaces: $nearbyPlaces,' +
        ' favoritePlaces: $favoritePlaces,' +
        ' place: $place,' +
        '}';
  }

  PlacesState copyWith({
    List<Place>? places,
    List<Place>? nearbyPlaces,
    List<Place>? favoritePlaces,
    Place? place,
  }) {
    return PlacesState(
      places: places ?? this.places,
      nearbyPlaces: nearbyPlaces ?? this.nearbyPlaces,
      favoritePlaces: favoritePlaces ?? this.favoritePlaces,
      place: place ?? this.place,
    );
  }

  Map<String, dynamic> toMap({
    String Function(String key)? keyMapper,
  }) {
    keyMapper ??= (key) => key;

    return {
      keyMapper('places'): this.places,
      keyMapper('nearbyPlaces'): this.nearbyPlaces,
      keyMapper('favoritePlaces'): this.favoritePlaces,
      keyMapper('place'): this.place,
    };
  }

  factory PlacesState.fromMap(
    Map<String, dynamic> map, {
    String Function(String key)? keyMapper,
  }) {
    keyMapper ??= (key) => key;

    return PlacesState(
      places: map[keyMapper('places')] as List<Place>,
      nearbyPlaces: map[keyMapper('nearbyPlaces')] as List<Place>,
      favoritePlaces: map[keyMapper('favoritePlaces')] as List<Place>,
      place: map[keyMapper('place')] as Place,
    );
  }

//</editor-fold>
}