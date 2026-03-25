import 'package:gastrorate/models/auth/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_user_request.g.dart';

@JsonSerializable(explicitToJson: true)
class UpdateUserRequest {
  final String? firstName;
  final String? lastName;
  final String? username;
  final Sex? sex;
  final DateTime? dateOfBirth;

  const UpdateUserRequest({
    this.firstName,
    this.lastName,
    this.username,
    this.sex,
    this.dateOfBirth,
  });

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserRequestToJson(this);
}
