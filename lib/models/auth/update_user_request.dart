import 'package:gastrorate/models/auth/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_user_request.g.dart';

@JsonSerializable(explicitToJson: true)
class UpdateUserRequest {
  String? username;
  Sex? sex;
  DateTime? dateOfBirth;

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) => _$UpdateUserRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateUserRequestToJson(this);

//<editor-fold desc="Data Methods">
  UpdateUserRequest({
    this.username,
    this.sex,
    this.dateOfBirth,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UpdateUserRequest &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          sex == other.sex &&
          dateOfBirth == other.dateOfBirth);

  @override
  int get hashCode => username.hashCode ^ sex.hashCode ^ dateOfBirth.hashCode;

  @override
  String toString() {
    return 'UpdateUserRequest{username: $username, sex: $sex, dateOfBirth: $dateOfBirth}';
  }

  UpdateUserRequest copyWith({
    String? username,
    Sex? sex,
    DateTime? dateOfBirth,
  }) {
    return UpdateUserRequest(
      username: username ?? this.username,
      sex: sex ?? this.sex,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }

//</editor-fold>
}
