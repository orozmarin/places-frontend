import 'package:gastrorate/models/place.dart';
import 'package:json_annotation/json_annotation.dart';

part 'places_state.g.dart';

@JsonSerializable(explicitToJson: true)
class PlacesState{
  List<Place>? places;
  List<Place>? nearbyPlaces;
  Place? place;

//<editor-fold desc="Data Methods">
  PlacesState({
    this.places,
    this.nearbyPlaces,
    this.place,
  });

  PlacesState.init(){
    this.places = List<Place>.empty();
    this.nearbyPlaces = List<Place>.empty();
  }

  factory PlacesState.fromJson(Map<String, dynamic> json) => _$PlacesStateFromJson(json);

  Map<String, dynamic> toJson() => _$PlacesStateToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlacesState &&
          runtimeType == other.runtimeType &&
          places == other.places &&
          nearbyPlaces == other.nearbyPlaces &&
          place == other.place);

  @override
  int get hashCode => places.hashCode ^ place.hashCode ^ nearbyPlaces.hashCode;

  @override
  String toString() {
    return 'PlacesState{' + ' places: $places,' + ' place: $place,' + ' nearbyPlaces: $nearbyPlaces,' + '}';
  }

  PlacesState copyWith({
    List<Place>? places,
    List<Place>? nearbyPlaces,
    Place? place,
  }) {
    return PlacesState(
      places: places ?? this.places,
      place: place ?? this.place,
      nearbyPlaces: nearbyPlaces ?? this.nearbyPlaces,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'places': this.places,
      'nearbyPlaces': this.nearbyPlaces,
      'place': this.place,
    };
  }

  factory PlacesState.fromMap(Map<String, dynamic> map) {
    return PlacesState(
      places: map['places'] as List<Place>,
      nearbyPlaces: map['nearbyPlaces'] as List<Place>,
      place: map['place'] as Place,
    );
  }

//</editor-fold>
}