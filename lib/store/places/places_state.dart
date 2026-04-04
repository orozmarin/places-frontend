import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/visit/place_visit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'places_state.g.dart';

@JsonSerializable(explicitToJson: true)
class PlacesState {
  List<Place>? places;
  List<Place>? nearbyPlaces;
  List<Place>? favoritePlaces;
  List<Place>? sharedPlaces;
  Place? place;

  PlacesState.init() {
    this.places = null;
    this.nearbyPlaces = null;
    this.favoritePlaces = null;
    this.sharedPlaces = null;
    this.currentPlaceVisits = null;
    this.selectedVisit = null;
  }

  factory PlacesState.fromJson(Map<String, dynamic> json) => _$PlacesStateFromJson(json);

  Map<String, dynamic> toJson() => _$PlacesStateToJson(this);

//<editor-fold desc="Data Methods">
  List<Place>? searchRecommendations;
  @JsonKey(includeToJson: false, includeFromJson: false)
  List<PlaceVisit>? currentPlaceVisits;
  @JsonKey(includeToJson: false, includeFromJson: false)
  PlaceVisit? selectedVisit;

  PlacesState({
    this.places,
    this.nearbyPlaces,
    this.favoritePlaces,
    this.sharedPlaces,
    this.place,
    this.searchRecommendations,
    this.currentPlaceVisits,
    this.selectedVisit,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlacesState &&
          runtimeType == other.runtimeType &&
          places == other.places &&
          nearbyPlaces == other.nearbyPlaces &&
          favoritePlaces == other.favoritePlaces &&
          sharedPlaces == other.sharedPlaces &&
          place == other.place &&
          searchRecommendations == other.searchRecommendations &&
          currentPlaceVisits == other.currentPlaceVisits &&
          selectedVisit == other.selectedVisit);

  @override
  int get hashCode =>
      places.hashCode ^
      nearbyPlaces.hashCode ^
      favoritePlaces.hashCode ^
      sharedPlaces.hashCode ^
      place.hashCode ^
      searchRecommendations.hashCode ^
      currentPlaceVisits.hashCode ^
      selectedVisit.hashCode;

  @override
  String toString() {
    return 'PlacesState{' +
        ' places: $places,' +
        ' nearbyPlaces: $nearbyPlaces,' +
        ' favoritePlaces: $favoritePlaces,' +
        ' sharedPlaces: $sharedPlaces,' +
        ' place: $place,' +
        ' searchRecommendations: $searchRecommendations,' +
        ' currentPlaceVisits: $currentPlaceVisits,' +
        ' selectedVisit: $selectedVisit,' +
        '}';
  }

  PlacesState copyWith({
    List<Place>? places,
    List<Place>? nearbyPlaces,
    List<Place>? favoritePlaces,
    List<Place>? sharedPlaces,
    Place? place,
    List<Place>? searchRecommendations,
    List<PlaceVisit>? currentPlaceVisits,
    PlaceVisit? selectedVisit,
    bool clearNearbyPlaces = false,
    bool clearSearchRecommendations = false,
    bool clearSelectedVisit = false,
  }) {
    return PlacesState(
      places: places ?? this.places,
      nearbyPlaces: clearNearbyPlaces ? null : (nearbyPlaces ?? this.nearbyPlaces),
      favoritePlaces: favoritePlaces ?? this.favoritePlaces,
      sharedPlaces: sharedPlaces ?? this.sharedPlaces,
      place: place ?? this.place,
      searchRecommendations: clearSearchRecommendations ? null : (searchRecommendations ?? this.searchRecommendations),
      currentPlaceVisits: currentPlaceVisits ?? this.currentPlaceVisits,
      selectedVisit: clearSelectedVisit ? null : (selectedVisit ?? this.selectedVisit),
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
      keyMapper('sharedPlaces'): this.sharedPlaces,
      keyMapper('place'): this.place,
      keyMapper('searchRecommendations'): this.searchRecommendations,
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
      sharedPlaces: map[keyMapper('sharedPlaces')] as List<Place>?,
      place: map[keyMapper('place')] as Place,
      searchRecommendations: map[keyMapper('searchRecommendations')] as List<Place>?,
    );
  }

//</editor-fold>
}
