class FriendRequestDto {
  final String? friendshipId;
  final String? requesterId;
  final String? requesterName;
  final String? requesterTag;
  final String? requesterUsername;
  final String? requesterProfileImageUrl;
  final String? status; // "PENDING" | "ACCEPTED" | "DECLINED"

  FriendRequestDto({
    this.friendshipId,
    this.requesterId,
    this.requesterName,
    this.requesterTag,
    this.requesterUsername,
    this.requesterProfileImageUrl,
    this.status,
  });

  factory FriendRequestDto.fromJson(Map<String, dynamic> json) {
    return FriendRequestDto(
      friendshipId: json['friendshipId'] as String?,
      requesterId: json['requesterId'] as String?,
      requesterName: json['requesterName'] as String?,
      requesterTag: json['requesterTag'] as String?,
      requesterUsername: json['requesterUsername'] as String?,
      requesterProfileImageUrl: json['requesterProfileImageUrl'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'friendshipId': friendshipId,
        'requesterId': requesterId,
        'requesterName': requesterName,
        'requesterTag': requesterTag,
        'requesterUsername': requesterUsername,
        'requesterProfileImageUrl': requesterProfileImageUrl,
        'status': status,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FriendRequestDto &&
          runtimeType == other.runtimeType &&
          friendshipId == other.friendshipId &&
          status == other.status);

  @override
  int get hashCode => friendshipId.hashCode ^ status.hashCode;
}
