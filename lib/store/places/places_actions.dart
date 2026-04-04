import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:dio/dio.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/models/coordinates.dart';
import 'package:gastrorate/models/from_where.dart';
import 'package:gastrorate/models/nearby_places_search_form.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/place_search_form.dart';
import 'package:gastrorate/models/visit/place_visit.dart';
import 'package:gastrorate/models/visit/update_place_visit_request.dart';
import 'package:gastrorate/router.dart';
import 'package:gastrorate/service/place_manager.dart';
import 'package:gastrorate/store/app_action.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/auth/auth.actions.dart';
import 'package:gastrorate/tools/location_helper.dart';
import 'package:gastrorate/tools/toast_helper.dart';
import 'package:go_router/go_router.dart';

class FetchPlacesAction extends AppAction {
  FetchPlacesAction({this.placeSearchForm});
  PlaceSearchForm? placeSearchForm;

  @override
  Future<AppState?> reduce() async {
    placeSearchForm ??= PlaceSearchForm(sortingMethod: PlaceSorting.DATE_DESC);
    List<Place>? places = <Place>[];
    User? user = state.authState.loggedUser;
    try {
      places = await PlaceManager().findPlaces(placeSearchForm!, user!.id!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        dispatch(LogoutAction());
      }
      return null;
    }
    dispatch(FetchPlacesSuccessAction(places));
    return null;
  }
}

class InitNewPlaceAction extends ReduxAction<AppState> {
  InitNewPlaceAction({required this.payload, required this.fromWhere, this.selectedVisit});
  final Place payload;
  final FromWhere fromWhere;
  final PlaceVisit? selectedVisit;

  @override
  Future<AppState?> reduce() async {
    rootNavigatorKey.currentContext!.push('/${fromWhere.name}/details');
    return state.copyWith(
      placesState: state.placesState.copyWith(
        place: payload,
        selectedVisit: selectedVisit,
        clearSelectedVisit: selectedVisit == null,
      ),
    );
  }
}

class SaveOrUpdatePlaceAction extends AppAction {
  SaveOrUpdatePlaceAction(this.payload);
  final Place payload;

  @override
  Future<AppState?> reduce() async {
    if (payload.userId == null || payload.userId!.isEmpty) {
      payload.userId = state.authState.loggedUser!.id;
    }
    Place place = await PlaceManager().saveOrUpdatePlace(payload);
    dispatch(SavePlaceSuccessAction(place));
    dispatch(FetchPlacesAction());
    dispatch(FetchFavoritePlacesAction());

    return null;
  }
}

class FetchPlacesSuccessAction extends ReduxAction<AppState> {
  FetchPlacesSuccessAction(this.payload);
  final List<Place> payload;

  @override
  Future<AppState?> reduce() async {
    return state.copyWith(placesState: state.placesState.copyWith(places: payload));
  }
}

class SavePlaceSuccessAction extends ReduxAction<AppState> {
  SavePlaceSuccessAction(this.payload);
  final Place payload;

  @override
  Future<AppState?> reduce() async {
    return state.copyWith(placesState: state.placesState.copyWith(place: payload));
  }
}

class DeletePlaceAction extends AppAction {
  DeletePlaceAction(this.payload);
  final Place payload;

  @override
  Future<AppState?> reduce() async {
    final userId = state.authState.loggedUser!.id!;
    await PlaceManager().deletePlace(payload.id!, userId);
    rootNavigatorKey.currentContext!.pop();
    rootNavigatorKey.currentContext!.pop();
    dispatch(FetchPlacesAction());
    dispatch(FetchFavoritePlacesAction());
    dispatch(FetchSharedPlacesAction(userId));
    return null;
  }
}

class AcknowledgeOwnershipTransferAction extends AppAction {
  final String placeId;
  AcknowledgeOwnershipTransferAction(this.placeId);

  @override
  Future<AppState?> reduce() async {
    await PlaceManager().acknowledgeOwnershipTransfer(placeId);
    dispatch(FetchPlacesAction());
    return null;
  }
}

class FetchNearbyPlacesAction extends AppAction {
  FetchNearbyPlacesAction();

  @override
  Future<AppState?> reduce() async {
    NearbyPlacesSearchForm npsf = await LocationHelper().getNearbyPlacesSearchForm();
    List<Place>? places = await PlaceManager().findNearbyPlaces(npsf);
    places = await Future.wait(places.map((place) async {
      if (place.coordinates != null) {
        final distance = await LocationHelper().getDistance(place.coordinates!);
        return place.copyWith(distance: distance);
      }
      return place;
    }));

    places = places
        .where((p) => p.photos != null && p.photos!.isNotEmpty)
        .where((p) => p.googleRating != null && p.googleRating! >= 3.5)
        .toList();
    places.sort((a, b) => (a.distance ?? double.maxFinite).compareTo(b.distance ?? double.maxFinite));
    if (places.length > 10) places = places.sublist(0, 10);

    dispatch(FetchNearbyPlacesSuccessAction(places));
    return null;
  }
}

class FetchNearbyPlacesSuccessAction extends ReduxAction<AppState> {
  FetchNearbyPlacesSuccessAction(this.payload);

  final List<Place> payload;

  @override
  Future<AppState?> reduce() async {
    return state.copyWith(placesState: state.placesState.copyWith(nearbyPlaces: payload));
  }
}

class FetchFavoritePlacesAction extends AppAction {
  FetchFavoritePlacesAction();

  @override
  Future<AppState?> reduce() async {
    User? user = state.authState.loggedUser;
    List<Place>? places = await PlaceManager().findFavoritePlaces(user!.id!);
    dispatch(FetchFavoritePlacesSuccessAction(places));
    return null;
  }
}

class RemoveCoVisitorAction extends AppAction {
  final String placeId;
  final String coVisitorUserId;
  RemoveCoVisitorAction(this.placeId, this.coVisitorUserId);

  @override
  Future<AppState?> reduce() async {
    try {
      final updatedPlace = await PlaceManager().removeCoVisitor(placeId, coVisitorUserId);
      final userId = state.authState.loggedUser!.id!;
      dispatch(FetchPlacesAction());
      dispatch(FetchSharedPlacesAction(userId));
      toastHelperMobile.showToastSuccess("Co-visitor removed");
      return state.copyWith(
        placesState: state.placesState.copyWith(place: updatedPlace),
      );
    } catch (_) {
      toastHelperMobile.showToastError("Failed to remove co-visitor");
    }
    return null;
  }
}

class FetchFavoritePlacesSuccessAction extends ReduxAction<AppState> {
  FetchFavoritePlacesSuccessAction(this.payload);

  final List<Place> payload;

  @override
  Future<AppState?> reduce() async {
    return state.copyWith(placesState: state.placesState.copyWith(favoritePlaces: payload));
  }
}

class FetchSharedPlacesAction extends AppAction {
  final String userId;
  FetchSharedPlacesAction(this.userId);

  @override
  Future<AppState?> reduce() async {
    List<Place>? places = <Place>[];
    try {
      places = await PlaceManager().findSharedPlaces(userId);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        dispatch(LogoutAction());
      }
      return null;
    }
    dispatch(FetchSharedPlacesSuccessAction(places));
    return null;
  }
}

class FetchSharedPlacesSuccessAction extends ReduxAction<AppState> {
  FetchSharedPlacesSuccessAction(this.payload);
  final List<Place> payload;

  @override
  Future<AppState?> reduce() async {
    return state.copyWith(placesState: state.placesState.copyWith(sharedPlaces: payload));
  }
}

class FetchSearchRecommendationsAction extends AppAction {
  @override
  Future<AppState?> reduce() async {
    final position = await LocationHelper().getCurrentLocation();
    final npsf = NearbyPlacesSearchForm(
      includedPrimaryTypes: ['restaurant'],
      maxResultCount: 20,
      rankPreference: 'POPULARITY',
      locationRestriction: LocationRestriction(
        circle: Circle(
          center: Coordinates(latitude: position.latitude, longitude: position.longitude),
          radius: 5000.0,
        ),
      ),
    );
    List<Place> places = await PlaceManager().findNearbyPlaces(npsf);
    places = await Future.wait(places.map((place) async {
      if (place.coordinates != null) {
        final distance = await LocationHelper().getDistance(place.coordinates!);
        return place.copyWith(distance: distance);
      }
      return place;
    }));
    dispatch(FetchSearchRecommendationsSuccessAction(places));
    return null;
  }
}

class FetchSearchRecommendationsSuccessAction extends ReduxAction<AppState> {
  FetchSearchRecommendationsSuccessAction(this.payload);
  final List<Place> payload;

  @override
  Future<AppState?> reduce() async {
    return state.copyWith(
      placesState: state.placesState.copyWith(searchRecommendations: payload),
    );
  }
}

class InvalidatePlacesAction extends ReduxAction<AppState> {
  @override
  AppState? reduce() {
    return state.copyWith(
      placesState: state.placesState.copyWith(
        clearNearbyPlaces: true,
        clearSearchRecommendations: true,
      ),
    );
  }
}

class FetchPlaceVisitsAction extends AppAction {
  final String placeId;
  FetchPlaceVisitsAction(this.placeId);

  @override
  Future<AppState?> reduce() async {
    final visits = await PlaceManager().getPlaceVisits(placeId);
    return state.copyWith(
      placesState: state.placesState.copyWith(currentPlaceVisits: visits),
    );
  }
}

class AddPlaceVisitAction extends AppAction {
  final PlaceVisit visit;
  AddPlaceVisitAction(this.visit);

  @override
  Future<AppState?> reduce() async {
    try {
      await PlaceManager().createPlaceVisit(visit);
      dispatch(FetchPlacesAction());
      dispatch(FetchPlaceVisitsAction(visit.placeId!));
    } catch (e) {
      toastHelperMobile.showToastError('Greška pri dodavanju posjeta');
    }
    return null;
  }
}

class UpdatePlaceVisitAction extends AppAction {
  final String visitId;
  final String placeId;
  final UpdatePlaceVisitRequest req;
  UpdatePlaceVisitAction(this.visitId, this.placeId, this.req);

  @override
  Future<AppState?> reduce() async {
    await PlaceManager().updatePlaceVisit(visitId, req);
    dispatch(FetchPlacesAction());
    dispatch(FetchPlaceVisitsAction(placeId));
    return null;
  }
}

class DeletePlaceVisitAction extends AppAction {
  final String visitId;
  final String placeId;
  DeletePlaceVisitAction(this.visitId, this.placeId);

  @override
  Future<AppState?> reduce() async {
    await PlaceManager().deletePlaceVisit(visitId);
    dispatch(FetchPlacesAction());
    dispatch(FetchPlaceVisitsAction(placeId));
    return null;
  }
}
