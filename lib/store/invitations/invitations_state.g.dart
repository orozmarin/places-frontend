// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invitations_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvitationsState _$InvitationsStateFromJson(Map<String, dynamic> json) =>
    InvitationsState(
      pendingInvitations: (json['pendingInvitations'] as List<dynamic>?)
          ?.map((e) => VisitInvitation.fromJson(e as Map<String, dynamic>))
          .toList(),
      activeVisit: json['activeVisit'] == null
          ? null
          : UserVisit.fromJson(json['activeVisit'] as Map<String, dynamic>),
      isLoading: json['isLoading'] as bool?,
    );

Map<String, dynamic> _$InvitationsStateToJson(InvitationsState instance) =>
    <String, dynamic>{
      'pendingInvitations': instance.pendingInvitations
          ?.map((e) => e.toJson())
          .toList(),
      'activeVisit': instance.activeVisit?.toJson(),
      'isLoading': instance.isLoading,
    };
