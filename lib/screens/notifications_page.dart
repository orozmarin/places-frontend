import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:gastrorate/models/friend_request_dto.dart';
import 'package:gastrorate/screens/notifications.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/friendships/friendships_actions.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(this),
      onInit: (Store<AppState> store) {
        final userId = store.state.authState.loggedUser?.id;
        if (userId != null) {
          store.dispatch(FetchAllFriendRequestsAction(userId));
        }
      },
      builder: (BuildContext context, ViewModel vm) => Notifications(
        pendingRequests: vm.pendingRequests,
        onAccept: vm.onAccept,
        onDecline: vm.onDecline,
      ),
    );
  }
}

class Factory extends VmFactory<AppState, NotificationsPage, ViewModel> {
  Factory(NotificationsPage widget) : super(widget);

  @override
  ViewModel? fromStore() => ViewModel(
        pendingRequests: state.friendshipsState.allRequests
                ?.where((r) => r.status == 'PENDING')
                .toList() ??
            [],
        onAccept: (String id) => dispatch(AcceptFriendRequestAction(id)),
        onDecline: (String id) => dispatch(DeclineFriendRequestAction(id)),
      );
}

class ViewModel extends Vm {
  final List<FriendRequestDto> pendingRequests;
  final Function(String friendshipId) onAccept;
  final Function(String friendshipId) onDecline;

  ViewModel({
    required this.pendingRequests,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          pendingRequests == other.pendingRequests;

  @override
  int get hashCode => super.hashCode ^ pendingRequests.hashCode;
}
