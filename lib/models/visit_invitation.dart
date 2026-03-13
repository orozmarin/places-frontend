import 'package:json_annotation/json_annotation.dart';

part 'visit_invitation.g.dart';

@JsonSerializable(explicitToJson: true)
class VisitInvitation {
  String? id;
  String? placeId;
  String? placeName;
  String? inviterId;
  String? inviteeId;
  String? status; // "PENDING" | "ACCEPTED" | "DECLINED"
  DateTime? createdAt;

  factory VisitInvitation.fromJson(Map<String, dynamic> json) => _$VisitInvitationFromJson(json);
  Map<String, dynamic> toJson() => _$VisitInvitationToJson(this);

  VisitInvitation({
    this.id,
    this.placeId,
    this.placeName,
    this.inviterId,
    this.inviteeId,
    this.status,
    this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VisitInvitation &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          placeId == other.placeId &&
          placeName == other.placeName &&
          inviterId == other.inviterId &&
          inviteeId == other.inviteeId &&
          status == other.status &&
          createdAt == other.createdAt);

  @override
  int get hashCode =>
      id.hashCode ^
      placeId.hashCode ^
      placeName.hashCode ^
      inviterId.hashCode ^
      inviteeId.hashCode ^
      status.hashCode ^
      createdAt.hashCode;

  @override
  String toString() =>
      'VisitInvitation{ id: $id, placeId: $placeId, placeName: $placeName, inviterId: $inviterId, inviteeId: $inviteeId, status: $status, createdAt: $createdAt }';

  VisitInvitation copyWith({
    String? id,
    String? placeId,
    String? placeName,
    String? inviterId,
    String? inviteeId,
    String? status,
    DateTime? createdAt,
  }) {
    return VisitInvitation(
      id: id ?? this.id,
      placeId: placeId ?? this.placeId,
      placeName: placeName ?? this.placeName,
      inviterId: inviterId ?? this.inviterId,
      inviteeId: inviteeId ?? this.inviteeId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'placeId': placeId,
        'placeName': placeName,
        'inviterId': inviterId,
        'inviteeId': inviteeId,
        'status': status,
        'createdAt': createdAt?.toIso8601String(),
      };

  factory VisitInvitation.fromMap(Map<String, dynamic> map) => VisitInvitation(
        id: map['id'] as String?,
        placeId: map['placeId'] as String?,
        placeName: map['placeName'] as String?,
        inviterId: map['inviterId'] as String?,
        inviteeId: map['inviteeId'] as String?,
        status: map['status'] as String?,
        createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      );
}
