import 'package:async_redux/async_redux.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/service/place_manager.dart';
import 'package:gastrorate/store/app_state.dart';

class FetchPlacesAction extends ReduxAction<AppState>{
  FetchPlacesAction();

  @override
  Future<AppState?> reduce() async{
    List<Place>? places = await PlaceManager().findPlaces();
    dispatch(FetchPlacesSuccessAction(places));
    return null;
  }
}

class InitNewPlaceAction extends ReduxAction<AppState>{
  InitNewPlaceAction(this.payload);
  final Place payload;

  @override
  Future<AppState?> reduce() async{
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

