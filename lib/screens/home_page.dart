import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/screens/home.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/places/places_actions.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(this),
      onInit: (Store<AppState> store) => store.dispatch(FetchPlacesAction()),
      builder: (BuildContext context, ViewModel vm) => Home(
        places: vm.places,
        onFindAllPlaces: vm.onFindAllPlaces,
        onDeletePlace: vm.onDeletePlace,
      ),
    );
  }
}

class Factory extends VmFactory<AppState, HomePage, ViewModel> {
  Factory(HomePage widget) : super(widget);

  @override
  ViewModel? fromStore() => ViewModel(
        places: state.placesState.places,
        onFindAllPlaces: () => dispatch(FetchPlacesAction()),
        onDeletePlace: (place) => dispatch(DeletePlaceAction(place)),
      );
}

class ViewModel extends Vm {
  final List<Place>? places;
  final Function() onFindAllPlaces;
  final Function(Place place) onDeletePlace;

  ViewModel({required this.places, required this.onFindAllPlaces, required this.onDeletePlace});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          places == other.places &&
          onFindAllPlaces == other.onFindAllPlaces &&
          onDeletePlace == other.onDeletePlace;

  @override
  int get hashCode => super.hashCode ^ places.hashCode ^ onFindAllPlaces.hashCode ^ onDeletePlace.hashCode;
}
