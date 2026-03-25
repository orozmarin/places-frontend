// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUserRequest _$UpdateUserRequestFromJson(Map<String, dynamic> json) =>
    UpdateUserRequest(
      username: json['username'] as String?,
      sex: $enumDecodeNullable(_$SexEnumMap, json['sex']),
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
    );

Map<String, dynamic> _$UpdateUserRequestToJson(UpdateUserRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'sex': _$SexEnumMap[instance.sex],
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
    };

const _$SexEnumMap = {
  Sex.MALE: 'MALE',
  Sex.FEMALE: 'FEMALE',
  Sex.UNDEFINED: 'UNDEFINED',
};
