// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      email: json['email'] as String?,
      password: json['password'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      sex: $enumDecodeNullable(_$SexEnumMap, json['sex']),
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'sex': _$SexEnumMap[instance.sex],
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
    };

const _$SexEnumMap = {
  Sex.MALE: 'MALE',
  Sex.FEMALE: 'FEMALE',
  Sex.UNDEFINED: 'UNDEFINED',
};
