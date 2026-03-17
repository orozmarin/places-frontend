class CoVisitor {
  String? userId;
  String? firstName;
  String? lastName;
  String? profileImageUrl;

  CoVisitor({this.userId, this.firstName, this.lastName, this.profileImageUrl});

  factory CoVisitor.fromJson(Map<String, dynamic> json) => CoVisitor(
        userId: json['userId'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        profileImageUrl: json['profileImageUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'firstName': firstName,
        'lastName': lastName,
        'profileImageUrl': profileImageUrl,
      };

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
}
