import 'dart:async';

import 'package:gastrorate/service/friendship_manager.dart';
import 'package:gastrorate/store/app_action.dart';
import 'package:gastrorate/store/app_state.dart';

class FetchFriendsAction extends AppAction {
  final String userId;
  FetchFriendsAction(this.userId);

  @override
  Future<AppState?> reduce() async {
    final friends = await FriendshipManager().getFriends(userId);
    return state.copyWith(
      friendshipsState: state.friendshipsState.copyWith(friends: friends),
    );
  }
}

class FetchPendingFriendRequestsAction extends AppAction {
  @override
  Future<AppState?> reduce() async {
    final userId = state.authState.loggedUser?.id;
    if (userId == null) return null;
    final requests = await FriendshipManager().getPendingRequests(userId);
    return state.copyWith(
      friendshipsState: state.friendshipsState.copyWith(pendingRequests: requests),
    );
  }
}

class SendFriendRequestAction extends AppAction {
  final String addresseeId;
  SendFriendRequestAction(this.addresseeId);

  @override
  Future<AppState?> reduce() async {
    await FriendshipManager().sendFriendRequest(addresseeId);
    final List<String> updated = [...(state.friendshipsState.sentRequestIds ?? []), addresseeId];
    return state.copyWith(
      friendshipsState: state.friendshipsState.copyWith(sentRequestIds: updated),
    );
  }
}

class FetchSentRequestsAction extends AppAction {
  @override
  Future<AppState?> reduce() async {
    final userId = state.authState.loggedUser?.id;
    if (userId == null) return null;
    final ids = await FriendshipManager().getSentPendingRequests(userId);
    return state.copyWith(
      friendshipsState: state.friendshipsState.copyWith(sentRequestIds: ids),
    );
  }
}

class AcceptFriendRequestAction extends AppAction {
  final String friendshipId;
  AcceptFriendRequestAction(this.friendshipId);

  @override
  Future<AppState?> reduce() async {
    await FriendshipManager().acceptFriendRequest(friendshipId);
    final userId = state.authState.loggedUser!.id!;
    dispatch(FetchPendingFriendRequestsAction());
    dispatch(FetchAllFriendRequestsAction(userId));
    dispatch(FetchFriendsAction(userId));
    return null;
  }
}

class DeclineFriendRequestAction extends AppAction {
  final String friendshipId;
  DeclineFriendRequestAction(this.friendshipId);

  @override
  Future<AppState?> reduce() async {
    await FriendshipManager().declineFriendRequest(friendshipId);
    final userId = state.authState.loggedUser!.id!;
    dispatch(FetchPendingFriendRequestsAction());
    dispatch(FetchAllFriendRequestsAction(userId));
    return null;
  }
}

class SearchUsersAction extends AppAction {
  final String query;
  SearchUsersAction(this.query);

  @override
  Future<AppState?> reduce() async {
    if (query.isEmpty) {
      return state.copyWith(
        friendshipsState: state.friendshipsState.copyWith(searchResults: []),
      );
    }
    final results = await FriendshipManager().searchUsers(query);
    return state.copyWith(
      friendshipsState: state.friendshipsState.copyWith(searchResults: results),
    );
  }
}

class RemoveFriendAction extends AppAction {
  final String friendId;
  RemoveFriendAction(this.friendId);

  @override
  Future<AppState?> reduce() async {
    await FriendshipManager().removeFriend(friendId);
    final userId = state.authState.loggedUser!.id!;
    dispatch(FetchFriendsAction(userId));
    return null;
  }
}

class FetchAllFriendRequestsAction extends AppAction {
  final String userId;
  FetchAllFriendRequestsAction(this.userId);

  @override
  Future<AppState?> reduce() async {
    final requests = await FriendshipManager().getAllFriendRequests(userId);
    return state.copyWith(
      friendshipsState: state.friendshipsState.copyWith(allRequests: requests),
    );
  }
}
