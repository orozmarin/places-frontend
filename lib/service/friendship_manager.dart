import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/models/friend_request_dto.dart';
import 'package:gastrorate/models/friendship.dart';
import 'package:gastrorate/service/api_service.dart';
import 'package:gastrorate/tools/services_uri_helper.dart';

class FriendshipManager {
  static const String SEND_FRIEND_REQUEST = "/friendships/request";
  static const String GET_PENDING_REQUESTS = "/friendships/pending/{userId}";
  static const String ACCEPT_FRIEND_REQUEST = "/friendships/{friendshipId}/accept";
  static const String DECLINE_FRIEND_REQUEST = "/friendships/{friendshipId}/decline";
  static const String GET_FRIENDS = "/friendships/{userId}";
  static const String SEARCH_USERS = "/user/search";
  static const String REMOVE_FRIEND = "/friendships/remove/{friendId}";
  static const String GET_ALL_FRIEND_REQUESTS = "/friendships/requests/{userId}";
  static const String GET_SENT_PENDING_REQUESTS = "/friendships/sent/{userId}";

  static final FriendshipManager _singleton = FriendshipManager._internal();

  factory FriendshipManager() => _singleton;

  FriendshipManager._internal();

  Dio client = ApiService.client;

  Future<Friendship> sendFriendRequest(String addresseeId) async {
    final String url = dotenv.env['API_BASE_URI'].toString() + SEND_FRIEND_REQUEST;
    final response = await client.post(url, data: {'addresseeId': addresseeId});
    return Friendship.fromJson(response.data);
  }

  Future<List<Friendship>> getPendingRequests(String userId) async {
    final Map<String, dynamic> params = <String, dynamic>{'userId': userId};
    final String url = ServicesUriHelper.getUrlWithParams(
        dotenv.env['API_BASE_URI'].toString() + GET_PENDING_REQUESTS, params);
    final response = await client.get(url);
    return (response.data as List<dynamic>)
        .map((e) => Friendship.fromJson(e))
        .toList();
  }

  Future<Friendship> acceptFriendRequest(String friendshipId) async {
    final Map<String, dynamic> params = <String, dynamic>{'friendshipId': friendshipId};
    final String url = ServicesUriHelper.getUrlWithParams(
        dotenv.env['API_BASE_URI'].toString() + ACCEPT_FRIEND_REQUEST, params);
    final response = await client.post(url);
    return Friendship.fromJson(response.data);
  }

  Future<void> declineFriendRequest(String friendshipId) async {
    final Map<String, dynamic> params = <String, dynamic>{'friendshipId': friendshipId};
    final String url = ServicesUriHelper.getUrlWithParams(
        dotenv.env['API_BASE_URI'].toString() + DECLINE_FRIEND_REQUEST, params);
    await client.post(url);
  }

  Future<List<User>> getFriends(String userId) async {
    final Map<String, dynamic> params = <String, dynamic>{'userId': userId};
    final String url = ServicesUriHelper.getUrlWithParams(
        dotenv.env['API_BASE_URI'].toString() + GET_FRIENDS, params);
    final response = await client.get(url);
    return (response.data as List<dynamic>)
        .map((e) => User.fromJson(e))
        .toList();
  }

  Future<List<User>> searchUsers(String query) async {
    final String url = dotenv.env['API_BASE_URI'].toString() + SEARCH_USERS;
    final response = await client.get(url, queryParameters: {'query': query});
    return (response.data as List<dynamic>)
        .map((e) => User.fromJson(e))
        .toList();
  }

  Future<void> removeFriend(String friendId) async {
    final Map<String, dynamic> params = <String, dynamic>{'friendId': friendId};
    final String url = ServicesUriHelper.getUrlWithParams(
        dotenv.env['API_BASE_URI'].toString() + REMOVE_FRIEND, params);
    await client.delete(url);
  }

  Future<List<String>> getSentPendingRequests(String userId) async {
    final Map<String, dynamic> params = <String, dynamic>{'userId': userId};
    final String url = ServicesUriHelper.getUrlWithParams(
        dotenv.env['API_BASE_URI'].toString() + GET_SENT_PENDING_REQUESTS, params);
    final response = await client.get(url);
    return (response.data as List<dynamic>).map((e) => e as String).toList();
  }

  Future<List<FriendRequestDto>> getAllFriendRequests(String userId) async {
    final Map<String, dynamic> params = <String, dynamic>{'userId': userId};
    final String url = ServicesUriHelper.getUrlWithParams(
        dotenv.env['API_BASE_URI'].toString() + GET_ALL_FRIEND_REQUESTS, params);
    final response = await client.get(url);
    return (response.data as List<dynamic>)
        .map((e) => FriendRequestDto.fromJson(e))
        .toList();
  }
}
