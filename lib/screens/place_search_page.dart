import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/screens/place_search_screen.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/places/places_actions.dart';

class PlaceSearchPage extends StatelessWidget {
  const PlaceSearchPage({
    super.key,
    required this.existingPlaces,
    required this.onPlaceSelected,
  });

  final List<Place>? existingPlaces;
  final Function(Place place) onPlaceSelected;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      onInit: (store) => store.dispatch(FetchSearchRecommendationsAction()),
      builder: (context, vm) => PlaceSearchScreen(
        existingPlaces: existingPlaces,
        onPlaceSelected: onPlaceSelected,
        searchRecommendations: vm.searchRecommendations,
        isLoadingRecs: vm.isLoadingRecs,
      ),
    );
  }
}

class _Factory extends VmFactory<AppState, PlaceSearchPage, _ViewModel> {
  _Factory(super.connector);

  @override
  _ViewModel fromStore() => _ViewModel(
        searchRecommendations: state.placesState.searchRecommendations,
        isLoadingRecs: state.placesState.searchRecommendations == null,
      );
}

class _ViewModel extends Vm {
  final List<Place>? searchRecommendations;
  final bool isLoadingRecs;

  _ViewModel({
    required this.searchRecommendations,
    required this.isLoadingRecs,
  }) : super(equals: [searchRecommendations, isLoadingRecs]);
}
