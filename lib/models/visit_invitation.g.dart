// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_invitation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitInvitation _$VisitInvitationFromJson(Map<String, dynamic> json) =>
    VisitInvitation(
      id: json['id'] as String?,
      placeId: json['placeId'] as String?,
      placeName: json['placeName'] as String?,
      inviterId: json['inviterId'] as String?,
      inviterName: json['inviterName'] as String?,
      inviterProfileImageUrl: json['inviterProfileImageUrl'] as String?,
      inviteeId: json['inviteeId'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$VisitInvitationToJson(VisitInvitation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'placeId': instance.placeId,
      'placeName': instance.placeName,
      'inviterId': instance.inviterId,
      'inviterName': instance.inviterName,
      'inviterProfileImageUrl': instance.inviterProfileImageUrl,
      'inviteeId': instance.inviteeId,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
