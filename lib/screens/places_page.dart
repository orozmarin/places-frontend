import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:gastrorate/models/from_where.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/place_search_form.dart';
import 'package:gastrorate/models/visit/place_visit.dart';
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
        if (store.state.placesState.places == null) {
          store.dispatch(FetchPlacesAction());
        }
        final userId = store.state.authState.loggedUser?.id;
        if (userId != null && store.state.placesState.sharedPlaces == null) {
          store.dispatch(FetchSharedPlacesAction(userId));
        }
      },
      builder: (BuildContext context, ViewModel vm) => Places(
        places: vm.places,
        sharedPlaces: vm.sharedPlaces,
        onFindAllPlaces: vm.onFindAllPlaces,
        onInitPlaceForm: vm.onInitPlaceForm,
        onLeavePlace: vm.onLeavePlace,
        onAcknowledgeTransfer: vm.onAcknowledgeTransfer,
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
    onInitPlaceForm: (Place place, PlaceVisit? visit) => dispatch(
      InitNewPlaceAction(payload: place, fromWhere: FromWhere.places, selectedVisit: visit),
    ),
    onLeavePlace: (place) => dispatch(RemoveCoVisitorAction(place.id!, state.authState.loggedUser!.id!)),
    onAcknowledgeTransfer: (placeId) => dispatch(AcknowledgeOwnershipTransferAction(placeId)),
  );
}

class ViewModel extends Vm {
  final List<Place>? places;
  final List<Place>? sharedPlaces;
  final Function(PlaceSearchForm) onFindAllPlaces;
  final Function(Place place, PlaceVisit? visit) onInitPlaceForm;
  final Function(Place place) onLeavePlace;
  final Function(String placeId) onAcknowledgeTransfer;

  ViewModel({
    required this.places,
    required this.sharedPlaces,
    required this.onFindAllPlaces,
    required this.onInitPlaceForm,
    required this.onLeavePlace,
    required this.onAcknowledgeTransfer,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          super == other &&
              other is ViewModel &&
              runtimeType == other.runtimeType &&
              places == other.places &&
              sharedPlaces == other.sharedPlaces &&
              onFindAllPlaces == other.onFindAllPlaces &&
              onInitPlaceForm == other.onInitPlaceForm &&
              onLeavePlace == other.onLeavePlace &&
              onAcknowledgeTransfer == other.onAcknowledgeTransfer;

  @override
  int get hashCode =>
      super.hashCode ^
      places.hashCode ^
      sharedPlaces.hashCode ^
      onFindAllPlaces.hashCode ^
      onInitPlaceForm.hashCode ^
      onLeavePlace.hashCode ^
      onAcknowledgeTransfer.hashCode;
}
