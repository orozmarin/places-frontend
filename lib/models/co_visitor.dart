import 'package:gastrorate/models/rating.dart';
import 'package:json_annotation/json_annotation.dart';

part 'co_visitor.g.dart';

@JsonSerializable(explicitToJson: true)
class CoVisitor {
  String? userId;
  String? firstName;
  String? lastName;
  String? profileImageUrl;
  Rating? rating;

  factory CoVisitor.fromJson(Map<String, dynamic> json) => _$CoVisitorFromJson(json);
  Map<String, dynamic> toJson() => _$CoVisitorToJson(this);

  CoVisitor({this.userId, this.firstName, this.lastName, this.profileImageUrl, this.rating});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CoVisitor &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          profileImageUrl == other.profileImageUrl &&
          rating == other.rating);

  @override
  int get hashCode =>
      userId.hashCode ^ firstName.hashCode ^ lastName.hashCode ^ profileImageUrl.hashCode ^ rating.hashCode;

  @override
  String toString() =>
      'CoVisitor{ userId: $userId, firstName: $firstName, lastName: $lastName, profileImageUrl: $profileImageUrl, rating: $rating }';

  CoVisitor copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? profileImageUrl,
    Rating? rating,
  }) {
    return CoVisitor(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'firstName': firstName,
        'lastName': lastName,
        'profileImageUrl': profileImageUrl,
        'rating': rating?.toMap(),
      };

  factory CoVisitor.fromMap(Map<String, dynamic> map) => CoVisitor(
        userId: map['userId'] as String?,
        firstName: map['firstName'] as String?,
        lastName: map['lastName'] as String?,
        profileImageUrl: map['profileImageUrl'] as String?,
        rating: map['rating'] != null ? Rating.fromMap(map['rating'] as Map<String, dynamic>) : null,
      );
}
