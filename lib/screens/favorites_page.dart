import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:gastrorate/models/from_where.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/screens/favorites.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/places/places_actions.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(this),
      onInit: (Store<AppState> store) async {
        store.dispatch(FetchFavoritePlacesAction());
      },
      builder: (BuildContext context, ViewModel vm) => Favorites(
        favoritePlaces: vm.favoritePlaces,
        onDeletePlace: vm.onDeletePlace,
        onInitPlaceForm: vm.onInitPlaceForm,
      ),
    );
  }
}

class Factory extends VmFactory<AppState, FavoritesPage, ViewModel> {
  Factory(FavoritesPage widget) : super(widget);

  @override
  ViewModel? fromStore() => ViewModel(
      favoritePlaces: state.placesState.favoritePlaces,
      onDeletePlace: (place) => dispatch(DeletePlaceAction(place)),
      onInitPlaceForm: (Place place) => dispatch(InitNewPlaceAction(payload: place, fromWhere: FromWhere.favorites)));
}

class ViewModel extends Vm {
  ViewModel({required this.favoritePlaces, required this.onDeletePlace, required this.onInitPlaceForm});

  final List<Place>? favoritePlaces;
  final Function(Place place) onDeletePlace;
  final Function(Place place) onInitPlaceForm;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          favoritePlaces == other.favoritePlaces &&
          onDeletePlace == other.onDeletePlace &&
          onInitPlaceForm == other.onInitPlaceForm;

  @override
  int get hashCode => super.hashCode ^ favoritePlaces.hashCode ^ onDeletePlace.hashCode ^ onInitPlaceForm.hashCode;
}
