// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rating _$RatingFromJson(Map<String, dynamic> json) => Rating(
      ambientRating: (json['ambientRating'] as num).toDouble(),
      foodRating: (json['foodRating'] as num).toDouble(),
      priceRating: (json['priceRating'] as num).toDouble(),
      restaurantRating: (json['restaurantRating'] as num).toDouble(),
    );

Map<String, dynamic> _$RatingToJson(Rating instance) => <String, dynamic>{
      'ambientRating': instance.ambientRating,
      'foodRating': instance.foodRating,
      'priceRating': instance.priceRating,
      'restaurantRating': instance.restaurantRating,
    };
