import 'package:gastrorate/models/co_visitor.dart';
import 'package:gastrorate/models/rating.dart';
import 'package:gastrorate/models/visit/consumed_item.dart';

class PlaceVisit {
  String? id;
  String? placeId;
  String? userId;
  DateTime? visitedAt;
  Rating? ownerRating;
  List<ConsumedItem>? consumedItems;
  List<String>? photoUrls;
  List<CoVisitor>? coVisitors; // populated from PlaceVisitResponse

  PlaceVisit({
    this.id,
    this.placeId,
    this.userId,
    this.visitedAt,
    this.ownerRating,
    this.consumedItems,
    this.photoUrls,
    this.coVisitors,
  });

  factory PlaceVisit.fromJson(Map<String, dynamic> json) {
    // Backend may return PlaceVisitResponse {visit: {...}, coVisitors: [...]}
    // or a flat PlaceVisit object. Detect and unwrap the wrapper format.
    final flat = json.containsKey('visit')
        ? json['visit'] as Map<String, dynamic>
        : json;
    return PlaceVisit(
      id: flat['id'] as String?,
      placeId: flat['placeId'] as String?,
      userId: flat['userId'] as String?,
      visitedAt: flat['visitedAt'] != null ? DateTime.parse(flat['visitedAt'] as String) : null,
      ownerRating: flat['ownerRating'] != null
          ? Rating.fromJson(flat['ownerRating'] as Map<String, dynamic>)
          : null,
      consumedItems: (flat['consumedItems'] as List<dynamic>?)
          ?.map((e) => ConsumedItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      photoUrls: (flat['photoUrls'] as List<dynamic>?)?.map((e) => e as String).toList(),
      coVisitors: (json['coVisitors'] as List<dynamic>?)
          ?.map((e) => CoVisitor.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (placeId != null) 'placeId': placeId,
        if (userId != null) 'userId': userId,
        if (visitedAt != null) 'visitedAt': visitedAt!.toIso8601String(),
        if (ownerRating != null) 'ownerRating': ownerRating!.toJson(),
        if (consumedItems != null) 'consumedItems': consumedItems!.map((e) => e.toJson()).toList(),
        if (photoUrls != null) 'photoUrls': photoUrls,
      };

  PlaceVisit copyWith({
    String? id,
    String? placeId,
    String? userId,
    DateTime? visitedAt,
    Rating? ownerRating,
    List<ConsumedItem>? consumedItems,
    List<String>? photoUrls,
    List<CoVisitor>? coVisitors,
  }) =>
      PlaceVisit(
        id: id ?? this.id,
        placeId: placeId ?? this.placeId,
        userId: userId ?? this.userId,
        visitedAt: visitedAt ?? this.visitedAt,
        ownerRating: ownerRating ?? this.ownerRating,
        consumedItems: consumedItems ?? this.consumedItems,
        photoUrls: photoUrls ?? this.photoUrls,
        coVisitors: coVisitors ?? this.coVisitors,
      );
}
