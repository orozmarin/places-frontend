import 'package:gastrorate/models/auth/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'social_login_request.g.dart';

@JsonSerializable(explicitToJson: true)
class SocialLoginRequest {
  final String idToken;
  final AuthProvider provider;

  SocialLoginRequest({required this.idToken, required this.provider});

  factory SocialLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$SocialLoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SocialLoginRequestToJson(this);
}
