import 'package:async_redux/async_redux.dart';
import 'package:gastrorate/models/from_where.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/place_search_form.dart';
import 'package:gastrorate/router.dart';
import 'package:gastrorate/service/place_manager.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:go_router/go_router.dart';

class FetchPlacesAction extends ReduxAction<AppState>{
  FetchPlacesAction({this.placeSearchForm});
  PlaceSearchForm? placeSearchForm;

  @override
  Future<AppState?> reduce() async{
    placeSearchForm ??= PlaceSearchForm(sortingMethod: PlaceSorting.DATE_DESC);
    List<Place>? places = await PlaceManager().findPlaces(placeSearchForm!);
    dispatch(FetchPlacesSuccessAction(places));
    return null;
  }
}

class InitNewPlaceAction extends ReduxAction<AppState>{
  InitNewPlaceAction({required this.payload, required this.fromWhere});
  final Place payload;
  final FromWhere fromWhere;

  @override
  Future<AppState?> reduce() async{
    rootNavigatorKey.currentContext!.go('/${fromWhere.name}/details');
    return state.copyWith(placesState: state.placesState.copyWith(place: payload));
  }
}

class SaveOrUpdatePlaceAction extends ReduxAction<AppState>{
  SaveOrUpdatePlaceAction(this.payload);
  final Place payload;

  @override
  Future<AppState?> reduce() async{
    Place place = await PlaceManager().saveOrUpdatePlace(payload);
    dispatch(SavePlaceSuccessAction(place));
    dispatch(FetchPlacesAction());
    return null;
  }
}

class FetchPlacesSuccessAction extends ReduxAction<AppState>{
  FetchPlacesSuccessAction(this.payload);
  final List<Place> payload;

  @override
  Future<AppState?> reduce() async{
    return state.copyWith(placesState: state.placesState.copyWith(places: payload));
  }
}

class SavePlaceSuccessAction extends ReduxAction<AppState>{
  SavePlaceSuccessAction(this.payload);
  final Place payload;

  @override
  Future<AppState?> reduce() async{
    return state.copyWith(placesState: state.placesState.copyWith(place: payload));
  }
}

class DeletePlaceAction extends ReduxAction<AppState>{
  DeletePlaceAction(this.payload);
  final Place payload;

  @override
  Future<AppState?> reduce() async{
    await PlaceManager().deletePlace(payload.id!);
    dispatch(FetchPlacesAction());
    return null;
  }
}

