import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:gastrorate/app.dart';
import 'package:gastrorate/models/restaurant.dart';
import 'package:gastrorate/screens/home.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/restaurants/restaurants_actions.dart';

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(this),
      onInit: (Store<AppState> store) async {
        await store.dispatch(FetchRestaurantsAction());
      },
      builder: (BuildContext context, ViewModel vm) => Home(restaurants: vm.restaurants,),);
  }
}

class Factory extends VmFactory<AppState, HomePage, ViewModel>{
  Factory(HomePage widget) : super(widget);

  @override
  ViewModel? fromStore() => ViewModel(restaurants: state.restaurantsState.restaurants);

}

class ViewModel extends Vm{
  final List<Restaurant>? restaurants;

  ViewModel({required this.restaurants});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          super == other && other is ViewModel && runtimeType == other.runtimeType && restaurants == other.restaurants;

  @override
  int get hashCode => super.hashCode ^ restaurants.hashCode;
}