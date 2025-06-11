// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      sex: $enumDecodeNullable(_$SexEnumMap, json['sex']),
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      status: $enumDecodeNullable(_$UserStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'password': instance.password,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'sex': _$SexEnumMap[instance.sex],
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'status': _$UserStatusEnumMap[instance.status],
    };

const _$SexEnumMap = {
  Sex.MALE: 'MALE',
  Sex.FEMALE: 'FEMALE',
  Sex.UNDEFINED: 'UNDEFINED',
};

const _$UserStatusEnumMap = {
  UserStatus.WAITING_FIRST_LOGIN: 'WAITING_FIRST_LOGIN',
  UserStatus.ACTIVE: 'ACTIVE',
  UserStatus.BLOCKED: 'BLOCKED',
  UserStatus.DELETED: 'DELETED',
};
