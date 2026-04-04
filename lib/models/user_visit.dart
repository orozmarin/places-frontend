import 'package:gastrorate/models/rating.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_visit.g.dart';

@JsonSerializable(explicitToJson: true)
class UserVisit {
  String? id;
  String? placeId;
  String? userId;
  Rating? rating;
  DateTime? visitedAt;
  String? status; // "PENDING" | "VISITED"
  String? placeVisitId; // nullable, backward compat

  factory UserVisit.fromJson(Map<String, dynamic> json) => _$UserVisitFromJson(json);
  Map<String, dynamic> toJson() => _$UserVisitToJson(this);

  UserVisit({
    this.id,
    this.placeId,
    this.userId,
    this.rating,
    this.visitedAt,
    this.status,
    this.placeVisitId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserVisit &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          placeId == other.placeId &&
          userId == other.userId &&
          rating == other.rating &&
          visitedAt == other.visitedAt &&
          status == other.status &&
          placeVisitId == other.placeVisitId);

  @override
  int get hashCode =>
      id.hashCode ^
      placeId.hashCode ^
      userId.hashCode ^
      rating.hashCode ^
      visitedAt.hashCode ^
      status.hashCode ^
      placeVisitId.hashCode;

  @override
  String toString() =>
      'UserVisit{ id: $id, placeId: $placeId, userId: $userId, rating: $rating, visitedAt: $visitedAt, status: $status, placeVisitId: $placeVisitId }';

  UserVisit copyWith({
    String? id,
    String? placeId,
    String? userId,
    Rating? rating,
    DateTime? visitedAt,
    String? status,
    String? placeVisitId,
  }) {
    return UserVisit(
      id: id ?? this.id,
      placeId: placeId ?? this.placeId,
      userId: userId ?? this.userId,
      rating: rating ?? this.rating,
      visitedAt: visitedAt ?? this.visitedAt,
      status: status ?? this.status,
      placeVisitId: placeVisitId ?? this.placeVisitId,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'placeId': placeId,
        'userId': userId,
        'rating': rating?.toMap(),
        'visitedAt': visitedAt?.toIso8601String(),
        'status': status,
        'placeVisitId': placeVisitId,
      };

  factory UserVisit.fromMap(Map<String, dynamic> map) => UserVisit(
        id: map['id'] as String?,
        placeId: map['placeId'] as String?,
        userId: map['userId'] as String?,
        rating: map['rating'] != null ? Rating.fromMap(map['rating']) : null,
        visitedAt: map['visitedAt'] != null ? DateTime.parse(map['visitedAt']) : null,
        status: map['status'] as String?,
        placeVisitId: map['placeVisitId'] as String?,
      );
}
