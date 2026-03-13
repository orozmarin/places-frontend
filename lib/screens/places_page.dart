import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:gastrorate/models/from_where.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/place_search_form.dart';
import 'package:gastrorate/screens/places.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/places/places_actions.dart';

class PlacesPage extends StatelessWidget {
  const PlacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(this),
      onInit: (Store<AppState> store) {
        store.dispatch(FetchPlacesAction());
        final userId = store.state.authState.loggedUser?.id;
        if (userId != null) {
          store.dispatch(FetchSharedPlacesAction(userId));
        }
      },
      builder: (BuildContext context, ViewModel vm) => Places(
        places: vm.places,
        sharedPlaces: vm.sharedPlaces,
        onFindAllPlaces: vm.onFindAllPlaces,
        onDeletePlace: vm.onDeletePlace,
        onInitPlaceForm: vm.onInitPlaceForm,
      ),
    );
  }
}

class Factory extends VmFactory<AppState, PlacesPage, ViewModel> {
  Factory(PlacesPage widget) : super(widget);

  @override
  ViewModel? fromStore() => ViewModel(
    places: state.placesState.places,
    sharedPlaces: state.placesState.sharedPlaces,
    onFindAllPlaces: (PlaceSearchForm psf) => dispatch(FetchPlacesAction(placeSearchForm: psf)),
    onDeletePlace: (place) => dispatch(DeletePlaceAction(place)),
    onInitPlaceForm: (Place place) => dispatch(InitNewPlaceAction(payload: place, fromWhere: FromWhere.places)),
  );
}

class ViewModel extends Vm {
  final List<Place>? places;
  final List<Place>? sharedPlaces;
  final Function(PlaceSearchForm) onFindAllPlaces;
  final Function(Place place) onDeletePlace;
  final Function(Place place) onInitPlaceForm;

  ViewModel(
      {required this.places,
        required this.sharedPlaces,
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
              sharedPlaces == other.sharedPlaces &&
              onFindAllPlaces == other.onFindAllPlaces &&
              onDeletePlace == other.onDeletePlace &&
              onInitPlaceForm == other.onInitPlaceForm;

  @override
  int get hashCode =>
      super.hashCode ^ places.hashCode ^ sharedPlaces.hashCode ^ onFindAllPlaces.hashCode ^ onDeletePlace.hashCode ^ onInitPlaceForm.hashCode;
}
