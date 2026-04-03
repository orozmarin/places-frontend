import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:gastrorate/models/from_where.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/screens/place_search_screen.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/places/places_actions.dart';

class PlaceSearchPage extends StatelessWidget {
  const PlaceSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      onInit: (store) {
        if (store.state.placesState.searchRecommendations == null) {
          store.dispatch(FetchSearchRecommendationsAction());
        }
      },
      builder: (context, vm) => PlaceSearchScreen(
        existingPlaces: vm.places,
        onPlaceSelected: vm.onInitPlaceForm,
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
        places: state.placesState.places,
        onInitPlaceForm: (place) =>
            dispatch(InitNewPlaceAction(payload: place, fromWhere: FromWhere.places)),
        searchRecommendations: state.placesState.searchRecommendations,
        isLoadingRecs: state.placesState.searchRecommendations == null,
      );
}

class _ViewModel extends Vm {
  final List<Place>? places;
  final Function(Place) onInitPlaceForm;
  final List<Place>? searchRecommendations;
  final bool isLoadingRecs;

  _ViewModel({
    required this.places,
    required this.onInitPlaceForm,
    required this.searchRecommendations,
    required this.isLoadingRecs,
  }) : super(equals: [places, searchRecommendations, isLoadingRecs]);
}
