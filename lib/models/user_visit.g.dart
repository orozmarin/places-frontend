// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_visit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVisit _$UserVisitFromJson(Map<String, dynamic> json) => UserVisit(
  id: json['id'] as String?,
  placeId: json['placeId'] as String?,
  userId: json['userId'] as String?,
  rating: json['rating'] == null
      ? null
      : Rating.fromJson(json['rating'] as Map<String, dynamic>),
  visitedAt: json['visitedAt'] == null
      ? null
      : DateTime.parse(json['visitedAt'] as String),
  status: json['status'] as String?,
);

Map<String, dynamic> _$UserVisitToJson(UserVisit instance) => <String, dynamic>{
  'id': instance.id,
  'placeId': instance.placeId,
  'userId': instance.userId,
  'rating': instance.rating?.toJson(),
  'visitedAt': instance.visitedAt?.toIso8601String(),
  'status': instance.status,
};
