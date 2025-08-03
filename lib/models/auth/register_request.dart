import 'package:gastrorate/models/auth/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable(explicitToJson: true)
class RegisterRequest{
  String? email;
  String? password;
  String? firstName;
  String? lastName;
  Sex? sex;
  DateTime? dateOfBirth;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => _$RegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);

//<editor-fold desc="Data Methods">
  RegisterRequest({
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.sex,
    this.dateOfBirth,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RegisterRequest &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          password == other.password &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          sex == other.sex &&
          dateOfBirth == other.dateOfBirth);

  @override
  int get hashCode =>
      email.hashCode ^ password.hashCode ^ firstName.hashCode ^ lastName.hashCode ^ sex.hashCode ^ dateOfBirth.hashCode;

  @override
  String toString() {
    return 'RegisterRequest{' +
        ' email: $email,' +
        ' password: $password,' +
        ' firstName: $firstName,' +
        ' lastName: $lastName,' +
        ' sex: $sex,' +
        ' dateOfBirth: $dateOfBirth,' +
        '}';
  }

  RegisterRequest copyWith({
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    Sex? sex,
    DateTime? dateOfBirth,
  }) {
    return RegisterRequest(
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      sex: sex ?? this.sex,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }

  Map<String, dynamic> toMap({
    String Function(String key)? keyMapper,
  }) {
    keyMapper ??= (key) => key;

    return {
      keyMapper('email'): this.email,
      keyMapper('password'): this.password,
      keyMapper('firstName'): this.firstName,
      keyMapper('lastName'): this.lastName,
      keyMapper('sex'): this.sex,
      keyMapper('dateOfBirth'): this.dateOfBirth,
    };
  }

  factory RegisterRequest.fromMap(
    Map<String, dynamic> map, {
    String Function(String key)? keyMapper,
  }) {
    keyMapper ??= (key) => key;

    return RegisterRequest(
      email: map[keyMapper('email')] as String,
      password: map[keyMapper('password')] as String,
      firstName: map[keyMapper('firstName')] as String,
      lastName: map[keyMapper('lastName')] as String,
      sex: map[keyMapper('sex')] as Sex,
      dateOfBirth: map[keyMapper('dateOfBirth')] as DateTime,
    );
  }

//</editor-fold>
}