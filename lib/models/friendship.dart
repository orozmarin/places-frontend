import 'package:json_annotation/json_annotation.dart';

part 'friendship.g.dart';

@JsonSerializable(explicitToJson: true)
class Friendship {
  String? id;
  String? requesterId;
  String? addresseeId;
  String? status; // "PENDING" | "ACCEPTED" | "DECLINED"
  DateTime? createdAt;

  factory Friendship.fromJson(Map<String, dynamic> json) => _$FriendshipFromJson(json);
  Map<String, dynamic> toJson() => _$FriendshipToJson(this);

  Friendship({
    this.id,
    this.requesterId,
    this.addresseeId,
    this.status,
    this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Friendship &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          requesterId == other.requesterId &&
          addresseeId == other.addresseeId &&
          status == other.status &&
          createdAt == other.createdAt);

  @override
  int get hashCode =>
      id.hashCode ^
      requesterId.hashCode ^
      addresseeId.hashCode ^
      status.hashCode ^
      createdAt.hashCode;

  @override
  String toString() =>
      'Friendship{ id: $id, requesterId: $requesterId, addresseeId: $addresseeId, status: $status, createdAt: $createdAt }';

  Friendship copyWith({
    String? id,
    String? requesterId,
    String? addresseeId,
    String? status,
    DateTime? createdAt,
  }) {
    return Friendship(
      id: id ?? this.id,
      requesterId: requesterId ?? this.requesterId,
      addresseeId: addresseeId ?? this.addresseeId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'requesterId': requesterId,
        'addresseeId': addresseeId,
        'status': status,
        'createdAt': createdAt?.toIso8601String(),
      };

  factory Friendship.fromMap(Map<String, dynamic> map) => Friendship(
        id: map['id'] as String?,
        requesterId: map['requesterId'] as String?,
        addresseeId: map['addresseeId'] as String?,
        status: map['status'] as String?,
        createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      );
}
