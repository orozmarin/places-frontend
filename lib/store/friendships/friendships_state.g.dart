// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendships_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendshipsState _$FriendshipsStateFromJson(Map<String, dynamic> json) =>
    FriendshipsState(
      friends: (json['friends'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      pendingRequests: (json['pendingRequests'] as List<dynamic>?)
          ?.map((e) => Friendship.fromJson(e as Map<String, dynamic>))
          .toList(),
      searchResults: (json['searchResults'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      isLoading: json['isLoading'] as bool?,
    );

Map<String, dynamic> _$FriendshipsStateToJson(
  FriendshipsState instance,
) => <String, dynamic>{
  'friends': instance.friends?.map((e) => e.toJson()).toList(),
  'pendingRequests': instance.pendingRequests?.map((e) => e.toJson()).toList(),
  'searchResults': instance.searchResults?.map((e) => e.toJson()).toList(),
  'isLoading': instance.isLoading,
};
