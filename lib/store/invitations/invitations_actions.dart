import 'dart:async';

import 'package:gastrorate/models/rating.dart';
import 'package:gastrorate/models/user_visit.dart';
import 'package:gastrorate/router.dart';
import 'package:gastrorate/service/invitation_manager.dart';
import 'package:gastrorate/store/app_action.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/places/places_actions.dart';
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
    final UserVisit visit = await InvitationManager().acceptInvitation(invitationId);
    rootNavigatorKey.currentContext!.push('/rate-shared-place');
    return state.copyWith(
      invitationsState: state.invitationsState.copyWith(activeVisit: visit),
    );
  }
}

class DeclineInvitationAction extends AppAction {
  final String invitationId;
  DeclineInvitationAction(this.invitationId);

  @override
  Future<AppState?> reduce() async {
    await InvitationManager().declineInvitation(invitationId);
    final userId = state.authState.loggedUser!.id!;
    dispatch(FetchPendingInvitationsAction(userId));
    return null;
  }
}

class SendVisitInvitationAction extends AppAction {
  final String placeId;
  final String inviteeId;
  SendVisitInvitationAction(this.placeId, this.inviteeId);

  @override
  Future<AppState?> reduce() async {
    await InvitationManager().sendInvitation(placeId, inviteeId);
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
    dispatch(FetchSharedPlacesAction(userId));
    rootNavigatorKey.currentContext!.pop();
    return state.copyWith(
      invitationsState: state.invitationsState.copyWith(activeVisit: null),
    );
  }
}
