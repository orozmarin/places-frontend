import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/models/friend_request_dto.dart';
import 'package:gastrorate/models/friendship.dart';
import 'package:json_annotation/json_annotation.dart';

part 'friendships_state.g.dart';

@JsonSerializable(explicitToJson: true)
class FriendshipsState {
  List<User>? friends;
  List<Friendship>? pendingRequests;
  List<User>? searchResults;
  bool? isLoading;
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<FriendRequestDto>? allRequests;
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<String>? sentRequestIds;

  FriendshipsState.init() {
    friends = List<User>.empty();
    pendingRequests = List<Friendship>.empty();
    searchResults = List<User>.empty();
    isLoading = false;
    allRequests = List<FriendRequestDto>.empty();
    sentRequestIds = List<String>.empty();
  }

  factory FriendshipsState.fromJson(Map<String, dynamic> json) =>
      _$FriendshipsStateFromJson(json);
  Map<String, dynamic> toJson() => _$FriendshipsStateToJson(this);

  FriendshipsState({this.friends, this.pendingRequests, this.searchResults, this.isLoading, this.allRequests, this.sentRequestIds});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FriendshipsState &&
          runtimeType == other.runtimeType &&
          friends == other.friends &&
          pendingRequests == other.pendingRequests &&
          searchResults == other.searchResults &&
          isLoading == other.isLoading &&
          allRequests == other.allRequests &&
          sentRequestIds == other.sentRequestIds);

  @override
  int get hashCode =>
      friends.hashCode ^
      pendingRequests.hashCode ^
      searchResults.hashCode ^
      isLoading.hashCode ^
      allRequests.hashCode ^
      sentRequestIds.hashCode;

  @override
  String toString() =>
      'FriendshipsState{ friends: $friends, pendingRequests: $pendingRequests, searchResults: $searchResults, isLoading: $isLoading, allRequests: $allRequests }';

  FriendshipsState copyWith({
    List<User>? friends,
    List<Friendship>? pendingRequests,
    List<User>? searchResults,
    bool? isLoading,
    List<FriendRequestDto>? allRequests,
    List<String>? sentRequestIds,
  }) {
    return FriendshipsState(
      friends: friends ?? this.friends,
      pendingRequests: pendingRequests ?? this.pendingRequests,
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? this.isLoading,
      allRequests: allRequests ?? this.allRequests,
      sentRequestIds: sentRequestIds ?? this.sentRequestIds,
    );
  }
}
