import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:gastrorate/models/restaurant.dart';
import 'package:gastrorate/screens/new_place.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/restaurants/restaurants_actions.dart';

class NewPlacePage extends StatelessWidget {
  const NewPlacePage({super.key, required this.foundRestaurant});

  final Restaurant foundRestaurant;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(this),
      onInit: (Store<AppState> store) => store.dispatch(InitNewPlaceAction(foundRestaurant)),
      builder: (BuildContext context, ViewModel vm) => NewPlace(
        restaurant: vm.foundRestaurant,
        onSavePlace: vm.onSavePlace,
      ),
    );
  }
}

class Factory extends VmFactory<AppState, NewPlacePage, ViewModel> {
  Factory(NewPlacePage widget) : super(widget);

  @override
  ViewModel? fromStore() => ViewModel(
        foundRestaurant: state.restaurantsState.currentRestaurant ?? Restaurant(),
        onSavePlace: (Restaurant restaurant) => dispatch(SaveOrUpdatePlaceAction(restaurant)),
      );
}

class ViewModel extends Vm {
  final Restaurant foundRestaurant;
  final Function(Restaurant restaurant) onSavePlace;

  ViewModel({required this.foundRestaurant, required this.onSavePlace});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          foundRestaurant == other.foundRestaurant &&
          onSavePlace == other.onSavePlace;

  @override
  int get hashCode => super.hashCode ^ foundRestaurant.hashCode ^ onSavePlace.hashCode;
}
