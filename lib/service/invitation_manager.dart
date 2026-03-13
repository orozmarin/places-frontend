import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/models/rating.dart';
import 'package:gastrorate/models/user_visit.dart';
import 'package:gastrorate/models/visit_invitation.dart';
import 'package:gastrorate/service/api_service.dart';
import 'package:gastrorate/tools/services_uri_helper.dart';

class InvitationManager {
  static const String SEND_INVITATION = "/visits/invite";
  static const String GET_PENDING_INVITATIONS = "/visits/invitations/pending/{userId}";
  static const String ACCEPT_INVITATION = "/visits/invitations/{invitationId}/accept";
  static const String DECLINE_INVITATION = "/visits/invitations/{invitationId}/decline";
  static const String RATE_VISIT = "/visits/{visitId}/rate";

  static final InvitationManager _singleton = InvitationManager._internal();

  factory InvitationManager() => _singleton;

  InvitationManager._internal();

  Dio client = ApiService.client;

  Future<VisitInvitation> sendInvitation(String placeId, String inviteeId) async {
    final String url = dotenv.env['API_BASE_URI'].toString() + SEND_INVITATION;
    final response = await client.post(url, data: {'placeId': placeId, 'inviteeId': inviteeId});
    return VisitInvitation.fromJson(response.data);
  }

  Future<List<VisitInvitation>> getPendingInvitations(String userId) async {
    final Map<String, dynamic> params = <String, dynamic>{'userId': userId};
    final String url = ServicesUriHelper.getUrlWithParams(
        dotenv.env['API_BASE_URI'].toString() + GET_PENDING_INVITATIONS, params);
    final response = await client.get(url);
    return (response.data as List<dynamic>)
        .map((e) => VisitInvitation.fromJson(e))
        .toList();
  }

  Future<UserVisit> acceptInvitation(String invitationId) async {
    final Map<String, dynamic> params = <String, dynamic>{'invitationId': invitationId};
    final String url = ServicesUriHelper.getUrlWithParams(
        dotenv.env['API_BASE_URI'].toString() + ACCEPT_INVITATION, params);
    final response = await client.post(url);
    return UserVisit.fromJson(response.data);
  }

  Future<void> declineInvitation(String invitationId) async {
    final Map<String, dynamic> params = <String, dynamic>{'invitationId': invitationId};
    final String url = ServicesUriHelper.getUrlWithParams(
        dotenv.env['API_BASE_URI'].toString() + DECLINE_INVITATION, params);
    await client.post(url);
  }

  Future<void> rateVisit(String visitId, Rating rating) async {
    final Map<String, dynamic> params = <String, dynamic>{'visitId': visitId};
    final String url = ServicesUriHelper.getUrlWithParams(
        dotenv.env['API_BASE_URI'].toString() + RATE_VISIT, params);
    await client.post(url, data: rating.toJson());
  }
}
