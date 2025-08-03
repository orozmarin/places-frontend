import 'package:gastrorate/models/auth/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

@JsonSerializable(explicitToJson: true)
class AuthResponse{
  String? token;
  User? user;

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);

//<editor-fold desc="Data Methods">
  AuthResponse({
    this.token,
    this.user,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthResponse && runtimeType == other.runtimeType && token == other.token && user == other.user);

  @override
  int get hashCode => token.hashCode ^ user.hashCode;

  @override
  String toString() {
    return 'AuthResponse{' + ' token: $token,' + ' user: $user,' + '}';
  }

  AuthResponse copyWith({
    String? token,
    User? user,
  }) {
    return AuthResponse(
      token: token ?? this.token,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap({
    String Function(String key)? keyMapper,
  }) {
    keyMapper ??= (key) => key;

    return {
      keyMapper('token'): this.token,
      keyMapper('user'): this.user,
    };
  }

  factory AuthResponse.fromMap(
    Map<String, dynamic> map, {
    String Function(String key)? keyMapper,
  }) {
    keyMapper ??= (key) => key;

    return AuthResponse(
      token: map[keyMapper('token')] as String,
      user: map[keyMapper('user')] as User,
    );
  }

//</editor-fold>
}