import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:gastrorate/models/coordinates.dart';
import 'package:gastrorate/models/from_where.dart';
import 'package:gastrorate/models/nearby_places_search_form.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/screens/home.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/places/places_actions.dart';
import 'package:gastrorate/tools/parse_helper.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(this),
      onInit: (Store<AppState> store) async {
        await fetchNearbyPlaces(store);
        store.dispatch(FetchPlacesAction());
      },
      builder: (BuildContext context, ViewModel vm) => Home(
        places: vm.places,
        nearbyPlaces: vm.nearbyPlaces,
        onFindAllPlaces: vm.onFindAllPlaces,
        onDeletePlace: vm.onDeletePlace,
        onInitPlaceForm: vm.onInitPlaceForm,
      ),
    );
  }

  Future<void> fetchNearbyPlaces(Store<AppState> store) async {
    Coordinates? initialPosition;
    await LocationHelper()
        .getCurrentLocation()
        .then((value) => initialPosition = Coordinates(latitude: value.latitude, longitude: value.longitude));
    if (initialPosition != null) {
      store.dispatch(FetchNearbyPlacesAction(
          nearbyPlacesSearchForm: NearbyPlacesSearchForm(
        includedTypes: ['restaurant'],
        maxResultCount: 10,
        locationRestriction: LocationRestriction(
          circle: Circle(
            center: initialPosition!,
            radius: 10000.0,
          ),
        ),
      )));
    }
  }
}

class Factory extends VmFactory<AppState, HomePage, ViewModel> {
  Factory(HomePage widget) : super(widget);

  @override
  ViewModel? fromStore() => ViewModel(
        places: state.placesState.places,
        nearbyPlaces: state.placesState.nearbyPlaces,
        onFindAllPlaces: () => dispatch(FetchPlacesAction()),
        onDeletePlace: (place) => dispatch(DeletePlaceAction(place)),
        onInitPlaceForm: (Place place) => dispatch(InitNewPlaceAction(payload: place, fromWhere: FromWhere.home)),
      );
}

class ViewModel extends Vm {
  final List<Place>? places;
  final List<Place>? nearbyPlaces;
  final Function() onFindAllPlaces;
  final Function(Place place) onDeletePlace;
  final Function(Place place) onInitPlaceForm;

  ViewModel(
      {required this.places,
      required this.nearbyPlaces,
      required this.onFindAllPlaces,
      required this.onDeletePlace,
      required this.onInitPlaceForm});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          places == other.places &&
          nearbyPlaces == other.nearbyPlaces &&
          onFindAllPlaces == other.onFindAllPlaces &&
          onDeletePlace == other.onDeletePlace &&
          onInitPlaceForm == other.onInitPlaceForm;

  @override
  int get hashCode =>
      super.hashCode ^
      places.hashCode ^
      nearbyPlaces.hashCode ^
      onFindAllPlaces.hashCode ^
      onDeletePlace.hashCode ^
      onInitPlaceForm.hashCode;
}
