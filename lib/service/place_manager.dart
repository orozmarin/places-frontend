import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/models/co_visitor.dart';
import 'package:gastrorate/models/nearby_places_search_form.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/place_search_form.dart';
import 'package:gastrorate/models/visit/place_visit.dart';
import 'package:gastrorate/models/visit/update_place_visit_request.dart';
import 'package:gastrorate/service/api_service.dart';
import 'package:gastrorate/tools/services_uri_helper.dart';

class PlaceManager {
  static const String SAVE_OR_UPDATE_PLACE = "/places/save-or-update";
  static const String FIND_ALL_PLACES = "/places/find/{userId}";
  static const String DELETE_PLACE = "/places/delete/{placeId}/{requestingUserId}";
  static const String ACKNOWLEDGE_TRANSFER = "/places/{placeId}/acknowledge-transfer";
  static const String FIND_FAVORITE_PLACES = "/places/find/favorites/{userId}";
  static const String FIND_SHARED_PLACES = "/places/find/shared/{userId}";
  static const String REMOVE_CO_VISITOR = "/visits/{placeId}/co-visitors/{coVisitorUserId}/remove";
  static const String PLACE_VISITS = "/visits/place-visits";
  static const String PLACE_VISITS_BY_PLACE = "/visits/place-visits/{placeId}";
  static const String PLACE_VISIT_BY_ID = "/visits/place-visits/visit/{visitId}";

  static const String FIND_NEARBY_PLACES_API = "https://places.googleapis.com/v1/places:searchNearby";

  static final PlaceManager _singleton = PlaceManager._internal();

  factory PlaceManager() {
    return _singleton;
  }

  PlaceManager._internal();

  Dio client = ApiService.client;
  Dio googleClient = Dio();

  Future<List<Place>> findPlaces(PlaceSearchForm psf, String userId) async {
      final Map<String, dynamic> params = <String, dynamic>{"userId": userId};
      final String url = ServicesUriHelper.getUrlWithParams(dotenv.env['API_BASE_URI'].toString() + FIND_ALL_PLACES, params);
      final Response<List<dynamic>> response = await client.get(url, data: psf.toJson());
      return (response.data as List<dynamic>).map((dynamic place) => Place.fromJson(place)).toList();

  }

  Future<Place> saveOrUpdatePlace(Place place) async {
    String url = dotenv.env['API_BASE_URI'].toString() + SAVE_OR_UPDATE_PLACE;
    final Response<dynamic> response = await client.post(url, data: place.toJson());
    return Place.fromJson(response.data);
  }

  Future<void> deletePlace(String placeId, String requestingUserId) async {
    final Map<String, dynamic> params = <String, dynamic>{
      "placeId": placeId,
      "requestingUserId": requestingUserId,
    };
    String url = dotenv.env['API_BASE_URI'].toString() + ServicesUriHelper.getUrlWithParams(DELETE_PLACE, params);
    await client.post(url);
    return;
  }

  Future<void> acknowledgeOwnershipTransfer(String placeId) async {
    final Map<String, dynamic> params = <String, dynamic>{"placeId": placeId};
    String url = dotenv.env['API_BASE_URI'].toString() +
        ServicesUriHelper.getUrlWithParams(ACKNOWLEDGE_TRANSFER, params);
    await client.post(url);
    return;
  }

  Future<List<Place>> findFavoritePlaces(String userId) async {
    final Map<String, dynamic> params = <String, dynamic>{"userId": userId};
    final String url = ServicesUriHelper.getUrlWithParams(dotenv.env['API_BASE_URI'].toString() + FIND_FAVORITE_PLACES, params);
    final Response<List<dynamic>> response = await client.get(url);
    return (response.data as List<dynamic>).map((dynamic place) => Place.fromJson(place)).toList();
  }

  Future<List<Place>> findSharedPlaces(String userId) async {
    final Map<String, dynamic> params = <String, dynamic>{"userId": userId};
    final String url = ServicesUriHelper.getUrlWithParams(
        dotenv.env['API_BASE_URI'].toString() + FIND_SHARED_PLACES, params);
    final Response<List<dynamic>> response = await client.get(url);
    return (response.data as List<dynamic>).map((dynamic place) => Place.fromJson(place)).toList();
  }

  Future<Place> removeCoVisitor(String placeId, String coVisitorUserId) async {
    final Map<String, dynamic> params = <String, dynamic>{
      "placeId": placeId,
      "coVisitorUserId": coVisitorUserId,
    };
    final String url = ServicesUriHelper.getUrlWithParams(
        dotenv.env['API_BASE_URI'].toString() + REMOVE_CO_VISITOR, params);
    final Response<dynamic> response = await client.post(url);
    return Place.fromJson(response.data);
  }

  Future<PlaceVisit?> createPlaceVisit(PlaceVisit visit) async {
    final String url = dotenv.env['API_BASE_URI'].toString() + PLACE_VISITS;
    final Response<dynamic> response = await client.post(url, data: visit.toJson());
    return _parsePlaceVisitResponse(response.data);
  }

  Future<List<PlaceVisit>> getPlaceVisits(String placeId) async {
    final Map<String, dynamic> params = <String, dynamic>{"placeId": placeId};
    final String url = ServicesUriHelper.getUrlWithParams(
        dotenv.env['API_BASE_URI'].toString() + PLACE_VISITS_BY_PLACE, params);
    final Response<dynamic> response = await client.get(url);
    return (response.data as List<dynamic>).map((e) => _parsePlaceVisitResponse(e)).toList();
  }

  Future<PlaceVisit?> updatePlaceVisit(String visitId, UpdatePlaceVisitRequest req) async {
    final Map<String, dynamic> params = <String, dynamic>{"visitId": visitId};
    final String url = ServicesUriHelper.getUrlWithParams(
        dotenv.env['API_BASE_URI'].toString() + PLACE_VISIT_BY_ID, params);
    final Response<dynamic> response = await client.patch(url, data: req.toJson());
    return _parsePlaceVisitResponse(response.data);
  }

  Future<bool> deletePlaceVisit(String visitId) async {
    final Map<String, dynamic> params = <String, dynamic>{"visitId": visitId};
    final String url = ServicesUriHelper.getUrlWithParams(
        dotenv.env['API_BASE_URI'].toString() + PLACE_VISIT_BY_ID, params);
    await client.delete(url);
    return true;
  }

  PlaceVisit _parsePlaceVisitResponse(dynamic data) {
    final visit = PlaceVisit.fromJson(data['visit'] as Map<String, dynamic>);
    final coVisitors = (data['coVisitors'] as List<dynamic>?)
        ?.map((e) => CoVisitor.fromJson(e as Map<String, dynamic>))
        .toList();
    return visit.copyWith(coVisitors: coVisitors);
  }

  Future<List<Place>> findNearbyPlaces(NearbyPlacesSearchForm npsf) async {
    final response = await googleClient.post(
      FIND_NEARBY_PLACES_API,
      data: npsf.toJson(),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': dotenv.env['MAPS_API'],
          'X-Goog-FieldMask': 'places.id,places.displayName,places.formattedAddress,places.location,places.photos,places.rating,places.priceLevel,places.regularOpeningHours,places.internationalPhoneNumber,places.websiteUri,places.googleMapsUri',
        },
      ),
    );

    final List<dynamic> placesJson = response.data['places'] ?? [];

    return placesJson.map((placeJson) => Place.fromGoogleJson(placeJson)).toList();
  }
}
