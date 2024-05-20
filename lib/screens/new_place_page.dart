import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/screens/new_place.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/places/places_actions.dart';

class NewPlacePage extends StatelessWidget {
  const NewPlacePage({super.key, required this.foundPlace});

  final Place foundPlace;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(this),
      onInit: (Store<AppState> store) async => await store.dispatch(InitNewPlaceAction(foundPlace)),
      builder: (BuildContext context, ViewModel vm) => NewPlace(
        place: vm.foundPlace,
        onSavePlace: vm.onSavePlace,
      ),
    );
  }
}

class Factory extends VmFactory<AppState, NewPlacePage, ViewModel> {
  Factory(NewPlacePage widget) : super(widget);

  @override
  ViewModel? fromStore() => ViewModel(
        foundPlace: state.placesState.place ?? Place(),
        onSavePlace: (Place place) => dispatch(SaveOrUpdatePlaceAction(place)),
      );
}

class ViewModel extends Vm {
  final Place foundPlace;
  final Function(Place place) onSavePlace;

  ViewModel({required this.foundPlace, required this.onSavePlace});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          foundPlace == other.foundPlace &&
          onSavePlace == other.onSavePlace;

  @override
  int get hashCode => super.hashCode ^ foundPlace.hashCode ^ onSavePlace.hashCode;
}
