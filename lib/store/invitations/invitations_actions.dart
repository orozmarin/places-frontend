import 'dart:async';

import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/rating.dart';
import 'package:gastrorate/models/user_visit.dart';
import 'package:gastrorate/router.dart';
import 'package:gastrorate/service/invitation_manager.dart';
import 'package:gastrorate/store/app_action.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/places/places_actions.dart';
import 'package:gastrorate/tools/toast_helper.dart';
import 'package:go_router/go_router.dart';

class FetchPendingInvitationsAction extends AppAction {
  final String userId;
  FetchPendingInvitationsAction(this.userId);

  @override
  Future<AppState?> reduce() async {
    final invitations = await InvitationManager().getPendingInvitations(userId);
    return state.copyWith(
      invitationsState: state.invitationsState.copyWith(pendingInvitations: invitations),
    );
  }
}

class AcceptInvitationAction extends AppAction {
  final String invitationId;
  AcceptInvitationAction(this.invitationId);

  @override
  Future<AppState?> reduce() async {
    try {
      final UserVisit visit = await InvitationManager().acceptInvitation(invitationId);
      final userId = state.authState.loggedUser!.id!;
      dispatch(FetchPendingInvitationsAction(userId));
      rootNavigatorKey.currentContext!.push('/rate-shared-place');
      return state.copyWith(
        invitationsState: state.invitationsState.copyWith(activeVisit: visit),
      );
    } catch (_) {
      toastHelperMobile.showToastError("Failed to accept invitation");
      return null;
    }
  }
}

class DeclineInvitationAction extends AppAction {
  final String invitationId;
  DeclineInvitationAction(this.invitationId);

  @override
  Future<AppState?> reduce() async {
    try {
      await InvitationManager().declineInvitation(invitationId);
      final userId = state.authState.loggedUser!.id!;
      dispatch(FetchPendingInvitationsAction(userId));
      toastHelperMobile.showToastSuccess("Invitation declined");
    } catch (_) {
      toastHelperMobile.showToastError("Failed to decline invitation");
    }
    return null;
  }
}

class SendVisitInvitationAction extends AppAction {
  final String placeId;
  final String inviteeId;
  SendVisitInvitationAction(this.placeId, this.inviteeId);

  @override
  Future<AppState?> reduce() async {
    try {
      await InvitationManager().sendInvitation(placeId, inviteeId);
      toastHelperMobile.showToastSuccess("Invitation sent");
    } catch (_) {
      toastHelperMobile.showToastError("Failed to send invitation");
    }
    return null;
  }
}

class RateVisitAction extends AppAction {
  final String visitId;
  final Rating rating;
  RateVisitAction(this.visitId, this.rating);

  @override
  Future<AppState?> reduce() async {
    await InvitationManager().rateVisit(visitId, rating);
    final userId = state.authState.loggedUser!.id!;
    final placeId = state.invitationsState.activeVisit?.placeId;
    final allPlaces = [
      ...?(state.placesState.places),
      ...?(state.placesState.sharedPlaces),
    ];
    final place = allPlaces.firstWhere((p) => p.id == placeId, orElse: () => Place());
    final label = place.name != null ? "${place.name} added!" : "Place added!";
    toastHelperMobile.showToastSuccess(label);
    dispatch(FetchSharedPlacesAction(userId));
    rootNavigatorKey.currentContext!.pop();
    return state.copyWith(
      invitationsState: state.invitationsState.copyWith(activeVisit: null),
    );
  }
}
