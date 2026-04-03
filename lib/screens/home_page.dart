import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:gastrorate/models/from_where.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/screens/home.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/friendships/friendships_actions.dart';
import 'package:gastrorate/store/places/places_actions.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(this),
      onInit: (Store<AppState> store) {
        if (store.state.placesState.nearbyPlaces == null) {
          store.dispatch(FetchNearbyPlacesAction());
        }
        if (store.state.placesState.places == null) {
          store.dispatch(FetchPlacesAction());
        }
        store.dispatch(FetchPendingFriendRequestsAction());
      },
      builder: (BuildContext context, ViewModel vm) => Home(
        places: vm.places,
        nearbyPlaces: vm.nearbyPlaces,
        onFindAllPlaces: vm.onFindAllPlaces,
        onDeletePlace: vm.onDeletePlace,
        onInitPlaceForm: vm.onInitPlaceForm,
        isLoading: vm.isLoading,
        onRefresh: vm.onRefresh,
      )
    );
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
        onInitPlaceForm: (Place place) => dispatch(
          InitNewPlaceAction(payload: place, fromWhere: FromWhere.home),
        ),
        isLoading: isWaiting(FetchNearbyPlacesAction) || state.placesState.nearbyPlaces == null,
        onRefresh: () async {
          dispatch(FetchNearbyPlacesAction());
          dispatch(FetchPlacesAction());
        },
      );
}

class ViewModel extends Vm {
  final List<Place>? places;
  final List<Place>? nearbyPlaces;
  final Function() onFindAllPlaces;
  final Function(Place place) onDeletePlace;
  final Function(Place place) onInitPlaceForm;
  final bool isLoading;
  final Future<void> Function() onRefresh;

  ViewModel(
      {required this.places,
      required this.nearbyPlaces,
      required this.onFindAllPlaces,
      required this.onDeletePlace,
    required this.onInitPlaceForm,
    required this.isLoading,
    required this.onRefresh,
  });

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
          onInitPlaceForm == other.onInitPlaceForm &&
          isLoading == other.isLoading &&
          onRefresh == other.onRefresh;

  @override
  int get hashCode =>
      super.hashCode ^
      places.hashCode ^
      nearbyPlaces.hashCode ^
      onFindAllPlaces.hashCode ^
      onDeletePlace.hashCode ^
      onInitPlaceForm.hashCode ^
      isLoading.hashCode ^
      onRefresh.hashCode;
}
