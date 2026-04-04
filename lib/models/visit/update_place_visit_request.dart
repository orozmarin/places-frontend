import 'package:gastrorate/models/rating.dart';
import 'package:gastrorate/models/visit/consumed_item.dart';

class UpdatePlaceVisitRequest {
  final DateTime? visitedAt;
  final Rating? ownerRating;
  final List<ConsumedItem>? consumedItems;
  final List<String>? photoUrls;

  UpdatePlaceVisitRequest({
    this.visitedAt,
    this.ownerRating,
    this.consumedItems,
    this.photoUrls,
  });

  Map<String, dynamic> toJson() => {
        if (visitedAt != null) 'visitedAt': visitedAt!.toIso8601String(),
        if (ownerRating != null) 'ownerRating': ownerRating!.toJson(),
        if (consumedItems != null)
          'consumedItems': consumedItems!.map((e) => e.toJson()).toList(),
        if (photoUrls != null) 'photoUrls': photoUrls,
      };
}
