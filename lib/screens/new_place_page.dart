import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/screens/new_place.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/places/places_actions.dart';

class NewPlacePage extends StatelessWidget {
  const NewPlacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(this),
      builder: (BuildContext context, ViewModel vm) => NewPlace(
        place: vm.foundPlace,
        onSavePlace: vm.onSavePlace,
        onDeletePlace: vm.onDeletePlace,
      ),
    );
  }
}

class Factory extends VmFactory<AppState, NewPlacePage, ViewModel> {
  Factory(NewPlacePage widget) : super(widget);

  @override
  ViewModel? fromStore() => ViewModel(
        foundPlace: state.placesState.place,
        onSavePlace: (Place place) => dispatch(SaveOrUpdatePlaceAction(place)),
        onDeletePlace: (place) => dispatch(DeletePlaceAction(place)),
      );
}

class ViewModel extends Vm {
  final Place? foundPlace;
  final Function(Place place) onSavePlace;
  final Function(Place place) onDeletePlace;

  ViewModel({required this.foundPlace, required this.onSavePlace, required this.onDeletePlace});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          foundPlace == other.foundPlace &&
          onSavePlace == other.onSavePlace &&
          onDeletePlace == other.onDeletePlace;

  @override
  int get hashCode => super.hashCode ^ foundPlace.hashCode ^ onSavePlace.hashCode ^ onDeletePlace.hashCode;
}
