import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

@JsonSerializable(explicitToJson: true)
class AuthResponse{
  String? token;
  String? email;
  String? userId;

//<editor-fold desc="Data Methods">
  AuthResponse({
    this.token,
    this.email,
    this.userId,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthResponse &&
          runtimeType == other.runtimeType &&
          token == other.token &&
          email == other.email &&
          userId == other.userId);

  @override
  int get hashCode => token.hashCode ^ email.hashCode ^ userId.hashCode;

  @override
  String toString() {
    return 'AuthResponse{' + ' token: $token,' + ' email: $email,' + ' userId: $userId,' + '}';
  }

  AuthResponse copyWith({
    String? token,
    String? email,
    String? userId,
  }) {
    return AuthResponse(
      token: token ?? this.token,
      email: email ?? this.email,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap({
    String Function(String key)? keyMapper,
  }) {
    keyMapper ??= (key) => key;

    return {
      keyMapper('token'): this.token,
      keyMapper('email'): this.email,
      keyMapper('userId'): this.userId,
    };
  }

  factory AuthResponse.fromMap(
    Map<String, dynamic> map, {
    String Function(String key)? keyMapper,
  }) {
    keyMapper ??= (key) => key;

    return AuthResponse(
      token: map[keyMapper('token')] as String,
      email: map[keyMapper('email')] as String,
      userId: map[keyMapper('userId')] as String,
    );
  }

//</editor-fold>
}