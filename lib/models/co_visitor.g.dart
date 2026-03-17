// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'co_visitor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoVisitor _$CoVisitorFromJson(Map<String, dynamic> json) => CoVisitor(
  userId: json['userId'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  profileImageUrl: json['profileImageUrl'] as String?,
  rating: json['rating'] == null
      ? null
      : Rating.fromJson(json['rating'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CoVisitorToJson(CoVisitor instance) => <String, dynamic>{
  'userId': instance.userId,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'profileImageUrl': instance.profileImageUrl,
  'rating': instance.rating?.toJson(),
};
