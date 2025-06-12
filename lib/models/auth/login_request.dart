import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable(explicitToJson: true)
class LoginRequest{
  String? email;
  String? password;

//<editor-fold desc="Data Methods">
  LoginRequest({
    this.email,
    this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoginRequest && runtimeType == other.runtimeType && email == other.email && password == other.password);

  @override
  int get hashCode => email.hashCode ^ password.hashCode;

  @override
  String toString() {
    return 'LoginRequest{' + ' email: $email,' + ' password: $password,' + '}';
  }

  LoginRequest copyWith({
    String? email,
    String? password,
  }) {
    return LoginRequest(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap({
    String Function(String key)? keyMapper,
  }) {
    keyMapper ??= (key) => key;

    return {
      keyMapper('email'): this.email,
      keyMapper('password'): this.password,
    };
  }

  factory LoginRequest.fromMap(
    Map<String, dynamic> map, {
    String Function(String key)? keyMapper,
  }) {
    keyMapper ??= (key) => key;

    return LoginRequest(
      email: map[keyMapper('email')] as String,
      password: map[keyMapper('password')] as String,
    );
  }

//</editor-fold>
}