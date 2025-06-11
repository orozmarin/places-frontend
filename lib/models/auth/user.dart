import 'package:gastrorate/tools/utils_helper.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  String? id;
  String? email;
  String? password;
  String? firstName;
  String? lastName;
  Sex? sex;
  DateTime? dateOfBirth;
  UserStatus? status;

  String getFullName() {
    return "$firstName $lastName";
  }

  String getUserInitials() {
    String firstNameInitial = UtilsHelper.extractFirstLetter(firstName ?? '');
    String lastNameInitial = UtilsHelper.extractFirstLetter(lastName ?? '');
    return firstNameInitial + lastNameInitial;
  }

//<editor-fold desc="Data Methods">
  User({
    this.id,
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.sex,
    this.dateOfBirth,
    this.status,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          password == other.password &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          sex == other.sex &&
          dateOfBirth == other.dateOfBirth &&
          status == other.status);

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      password.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      sex.hashCode ^
      dateOfBirth.hashCode ^
      status.hashCode;

  @override
  String toString() {
    return 'User{' +
        ' id: $id,' +
        ' email: $email,' +
        ' password: $password,' +
        ' firstName: $firstName,' +
        ' lastName: $lastName,' +
        ' sex: $sex,' +
        ' dateOfBirth: $dateOfBirth,' +
        ' status: $status,' +
        '}';
  }

  User copyWith({
    String? id,
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    Sex? sex,
    DateTime? dateOfBirth,
    UserStatus? status,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      sex: sex ?? this.sex,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap({
    String Function(String key)? keyMapper,
  }) {
    keyMapper ??= (key) => key;

    return {
      keyMapper('id'): this.id,
      keyMapper('email'): this.email,
      keyMapper('password'): this.password,
      keyMapper('firstName'): this.firstName,
      keyMapper('lastName'): this.lastName,
      keyMapper('sex'): this.sex,
      keyMapper('dateOfBirth'): this.dateOfBirth,
      keyMapper('status'): this.status,
    };
  }

  factory User.fromMap(
    Map<String, dynamic> map, {
    String Function(String key)? keyMapper,
  }) {
    keyMapper ??= (key) => key;

    return User(
      id: map[keyMapper('id')] as String,
      email: map[keyMapper('email')] as String,
      password: map[keyMapper('password')] as String,
      firstName: map[keyMapper('firstName')] as String,
      lastName: map[keyMapper('lastName')] as String,
      sex: map[keyMapper('sex')] as Sex,
      dateOfBirth: map[keyMapper('dateOfBirth')] as DateTime,
      status: map[keyMapper('status')] as UserStatus,
    );
  }

//</editor-fold>
}

enum UserStatus {
  WAITING_FIRST_LOGIN,
  ACTIVE,
  BLOCKED,
  DELETED,
}

enum Sex {
  MALE,
  FEMALE,
  UNDEFINED,
}
