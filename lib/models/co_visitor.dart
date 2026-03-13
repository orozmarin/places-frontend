import 'package:json_annotation/json_annotation.dart';

part 'co_visitor.g.dart';

@JsonSerializable(explicitToJson: true)
class CoVisitor {
  String? userId;
  String? firstName;
  String? lastName;
  String? profileImageUrl;

  factory CoVisitor.fromJson(Map<String, dynamic> json) => _$CoVisitorFromJson(json);
  Map<String, dynamic> toJson() => _$CoVisitorToJson(this);

  CoVisitor({this.userId, this.firstName, this.lastName, this.profileImageUrl});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CoVisitor &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          profileImageUrl == other.profileImageUrl);

  @override
  int get hashCode =>
      userId.hashCode ^ firstName.hashCode ^ lastName.hashCode ^ profileImageUrl.hashCode;

  @override
  String toString() =>
      'CoVisitor{ userId: $userId, firstName: $firstName, lastName: $lastName, profileImageUrl: $profileImageUrl }';

  CoVisitor copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? profileImageUrl,
  }) {
    return CoVisitor(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'firstName': firstName,
        'lastName': lastName,
        'profileImageUrl': profileImageUrl,
      };

  factory CoVisitor.fromMap(Map<String, dynamic> map) => CoVisitor(
        userId: map['userId'] as String?,
        firstName: map['firstName'] as String?,
        lastName: map['lastName'] as String?,
        profileImageUrl: map['profileImageUrl'] as String?,
      );
}
