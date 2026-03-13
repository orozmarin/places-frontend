import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:gastrorate/models/visit_invitation.dart';
import 'package:gastrorate/screens/pending_invitations.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/invitations/invitations_actions.dart';

class PendingInvitationsPage extends StatelessWidget {
  const PendingInvitationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(this),
      onInit: (Store<AppState> store) {
        final userId = store.state.authState.loggedUser?.id;
        if (userId != null) {
          store.dispatch(FetchPendingInvitationsAction(userId));
        }
      },
      builder: (BuildContext context, ViewModel vm) => PendingInvitations(
        invitations: vm.pendingInvitations,
        onAccept: vm.onAccept,
        onDecline: vm.onDecline,
      ),
    );
  }
}

class Factory extends VmFactory<AppState, PendingInvitationsPage, ViewModel> {
  Factory(PendingInvitationsPage widget) : super(widget);

  @override
  ViewModel? fromStore() => ViewModel(
        pendingInvitations: state.invitationsState.pendingInvitations,
        onAccept: (String id) => dispatch(AcceptInvitationAction(id)),
        onDecline: (String id) => dispatch(DeclineInvitationAction(id)),
      );
}

class ViewModel extends Vm {
  final List<VisitInvitation>? pendingInvitations;
  final Function(String invitationId) onAccept;
  final Function(String invitationId) onDecline;

  ViewModel({
    required this.pendingInvitations,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          pendingInvitations == other.pendingInvitations &&
          onAccept == other.onAccept &&
          onDecline == other.onDecline;

  @override
  int get hashCode =>
      super.hashCode ^ pendingInvitations.hashCode ^ onAccept.hashCode ^ onDecline.hashCode;
}
