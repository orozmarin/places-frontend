import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/screens/friends.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/friendships/friendships_actions.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(this),
      onInit: (Store<AppState> store) {
        store.dispatch(SearchUsersAction(''));
        store.dispatch(FetchSentRequestsAction());
        final userId = store.state.authState.loggedUser?.id;
        if (userId != null) {
          store.dispatch(FetchFriendsAction(userId));
          store.dispatch(FetchPendingFriendRequestsAction());
        }
      },
      builder: (BuildContext context, ViewModel vm) => Friends(
        friends: vm.friends,
        searchResults: vm.searchResults,
        sentRequestIds: vm.sentRequestIds,
        onSendRequest: vm.onSendRequest,
        onSearch: vm.onSearch,
        onRemove: vm.onRemove,
      ),
    );
  }
}

class Factory extends VmFactory<AppState, FriendsPage, ViewModel> {
  Factory(FriendsPage widget) : super(widget);

  @override
  ViewModel? fromStore() => ViewModel(
        friends: state.friendshipsState.friends,
        searchResults: state.friendshipsState.searchResults,
        sentRequestIds: state.friendshipsState.sentRequestIds ?? [],
        onSendRequest: (String userId) => dispatch(SendFriendRequestAction(userId)),
        onSearch: (String query) => dispatch(SearchUsersAction(query)),
        onRemove: (String id) => dispatch(RemoveFriendAction(id)),
      );
}

class ViewModel extends Vm {
  final List<User>? friends;
  final List<User>? searchResults;
  final List<String> sentRequestIds;
  final Function(String userId) onSendRequest;
  final Function(String query) onSearch;
  final Function(String userId) onRemove;

  ViewModel({
    required this.friends,
    required this.searchResults,
    required this.sentRequestIds,
    required this.onSendRequest,
    required this.onSearch,
    required this.onRemove,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          friends == other.friends &&
          searchResults == other.searchResults &&
          sentRequestIds == other.sentRequestIds;

  @override
  int get hashCode =>
      super.hashCode ^ friends.hashCode ^ searchResults.hashCode ^ sentRequestIds.hashCode;
}
