import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/models/restaurant.dart';
import 'package:gastrorate/tools/services_uri_helper.dart';

class RestaurantManager {
  static const String SAVE_OR_UPDATE_RESTAURANT = "/restaurants/save-or-update";
  static const String FIND_ALL_RESTAURANTS = "/restaurants/find";
  static const String FIND_RESTAURANT_BY_NAME = "/restaurants/find/{name}";
  static const String FIND_RESTAURANT_BY_RATING = "/restaurants/find/rating/{rating}";
  static const String DELETE_RESTAURANT = "/restaurants/delete/{placeId}";

  static final RestaurantManager _singleton = RestaurantManager._internal();

  factory RestaurantManager() {
    return _singleton;
  }

  RestaurantManager._internal();

  Dio client = Dio();

  Future<List<Restaurant>> findRestaurants() async {
    String url = dotenv.env['API_BASE_URI'].toString() + FIND_ALL_RESTAURANTS;
    final Response<List<dynamic>> response = await client.get(url);
    return (response.data as List<dynamic>).map((dynamic restaurant) => Restaurant.fromJson(restaurant)).toList();
  }

  Future<Restaurant> saveOrUpdatePlace(Restaurant restaurant) async {
    String url = dotenv.env['API_BASE_URI'].toString() + SAVE_OR_UPDATE_RESTAURANT;
    final Response<dynamic> response = await client.post(url, data: restaurant.toJson());
    return Restaurant.fromJson(response.data);
  }

  Future<void> deletePlace(String placeId) async {
    final Map<String, dynamic> params = <String, dynamic>{"placeId": placeId};
    String url = dotenv.env['API_BASE_URI'].toString() + ServicesUriHelper.getUrlWithParams(DELETE_RESTAURANT, params);
    await client.post(url);
    return;
  }
}
