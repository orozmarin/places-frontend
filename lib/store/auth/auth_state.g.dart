// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthState _$AuthStateFromJson(Map<String, dynamic> json) => AuthState(
      loggedUser: json['loggedUser'] == null
          ? null
          : User.fromJson(json['loggedUser'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthStateToJson(AuthState instance) =>
    <String, dynamic>{
      'loggedUser': instance.loggedUser?.toJson(),
    };
