import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/models/nearby_places_search_form.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/place_search_form.dart';
import 'package:gastrorate/service/api_service.dart';
import 'package:gastrorate/tools/services_uri_helper.dart';

class PlaceManager {
  static const String SAVE_OR_UPDATE_PLACE = "/places/save-or-update";
  static const String FIND_ALL_PLACES = "/places/find";
  static const String FIND_PLACE_BY_NAME = "/places/find/{name}";
  static const String FIND_PLACE_BY_RATING = "/places/find/rating/{rating}";
  static const String DELETE_PLACE = "/places/delete/{placeId}";
  static const String FIND_FAVORITE_PLACES = "/places/find/favorites";

  static const String FIND_NEARBY_PLACES_API = "https://places.googleapis.com/v1/places:searchNearby";

  static final PlaceManager _singleton = PlaceManager._internal();

  factory PlaceManager() {
    return _singleton;
  }

  PlaceManager._internal();

  Dio client = ApiService.client;
  Dio googleClient = Dio();

  Future<List<Place>> findPlaces(PlaceSearchForm psf) async {
    String url = dotenv.env['API_BASE_URI'].toString() + FIND_ALL_PLACES;
    final Response<List<dynamic>> response = await client.get(url, data: psf.toJson());
    return (response.data as List<dynamic>).map((dynamic place) => Place.fromJson(place)).toList();
  }

  Future<Place> saveOrUpdatePlace(Place place) async {
    String url = dotenv.env['API_BASE_URI'].toString() + SAVE_OR_UPDATE_PLACE;
    final Response<dynamic> response = await client.post(url, data: place.toJson());
    return Place.fromJson(response.data);
  }

  Future<void> deletePlace(String placeId) async {
    final Map<String, dynamic> params = <String, dynamic>{"placeId": placeId};
    String url = dotenv.env['API_BASE_URI'].toString() + ServicesUriHelper.getUrlWithParams(DELETE_PLACE, params);
    await client.post(url);
    return;
  }

  Future<List<Place>> findFavoritePlaces() async {
    String url = dotenv.env['API_BASE_URI'].toString() + FIND_FAVORITE_PLACES;
    final Response<List<dynamic>> response = await client.get(url);
    return (response.data as List<dynamic>).map((dynamic place) => Place.fromJson(place)).toList();
  }

  Future<List<Place>> findNearbyPlaces(NearbyPlacesSearchForm npsf) async {
    final response = await googleClient.post(
      FIND_NEARBY_PLACES_API,
      data: npsf.toJson(),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': dotenv.env['MAPS_API'],
          'X-Goog-FieldMask': 'places',
        },
      ),
    );

    final List<dynamic> placesJson = response.data['places'] ?? [];

    return placesJson.map((placeJson) => Place.fromGoogleJson(placeJson)).toList();
  }
}
