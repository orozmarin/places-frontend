// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialLoginRequest _$SocialLoginRequestFromJson(Map<String, dynamic> json) =>
    SocialLoginRequest(
      idToken: json['idToken'] as String,
      provider: $enumDecode(_$AuthProviderEnumMap, json['provider']),
    );

Map<String, dynamic> _$SocialLoginRequestToJson(
        SocialLoginRequest instance) =>
    <String, dynamic>{
      'idToken': instance.idToken,
      'provider': _$AuthProviderEnumMap[instance.provider]!,
    };

const _$AuthProviderEnumMap = {
  AuthProvider.EMAIL: 'EMAIL',
  AuthProvider.GOOGLE: 'GOOGLE',
  AuthProvider.APPLE: 'APPLE',
};
