// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Place _$PlaceFromJson(Map<String, dynamic> json) => Place(
  id: json['id'] as String?,
  userId: json['userId'] as String?,
  name: json['name'] as String?,
  address: json['address'] as String?,
  city: json['city'] as String?,
  postalCode: (json['postalCode'] as num?)?.toInt(),
  country: json['country'] as String?,
  contactNumber: json['contactNumber'] as String?,
  openingHours: json['openingHours'] == null
      ? null
      : PlaceOpeningHours.fromJson(
          json['openingHours'] as Map<String, dynamic>,
        ),
  photos: (json['photos'] as List<dynamic>?)
      ?.map((e) => Photo.fromJson(e as Map<String, dynamic>))
      .toList(),
  priceLevel: $enumDecodeNullable(_$PriceLevelEnumMap, json['priceLevel']),
  reviews: (json['reviews'] as List<dynamic>?)
      ?.map((e) => PlaceReview.fromJson(e as Map<String, dynamic>))
      .toList(),
  googleRating: (json['googleRating'] as num?)?.toDouble(),
  url: json['url'] as String?,
  webSiteUrl: json['webSiteUrl'] as String?,
  coordinates: json['coordinates'] == null
      ? null
      : Coordinates.fromJson(json['coordinates'] as Map<String, dynamic>),
  rating: json['rating'] == null
      ? null
      : Rating.fromJson(json['rating'] as Map<String, dynamic>),
  visitedAt: json['visitedAt'] == null
      ? null
      : DateTime.parse(json['visitedAt'] as String),
  isFavorite: json['isFavorite'] as bool?,
  distance: (json['distance'] as num?)?.toDouble(),
)..coVisitors = (json['coVisitors'] as List<dynamic>?)
    ?.map((e) => CoVisitor.fromJson(e as Map<String, dynamic>))
    .toList();

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'name': instance.name,
  'address': instance.address,
  'city': instance.city,
  'postalCode': instance.postalCode,
  'country': instance.country,
  'contactNumber': instance.contactNumber,
  'openingHours': instance.openingHours?.toJson(),
  'photos': instance.photos?.map((e) => e.toJson()).toList(),
  'priceLevel': _$PriceLevelEnumMap[instance.priceLevel],
  'reviews': instance.reviews?.map((e) => e.toJson()).toList(),
  'googleRating': instance.googleRating,
  'url': instance.url,
  'webSiteUrl': instance.webSiteUrl,
  'coordinates': instance.coordinates?.toJson(),
  'rating': instance.rating?.toJson(),
  'coVisitors': instance.coVisitors?.map((e) => e.toJson()).toList(),
  'visitedAt': instance.visitedAt?.toIso8601String(),
  'isFavorite': instance.isFavorite,
  'distance': instance.distance,
};

const _$PriceLevelEnumMap = {
  PriceLevel.FREE: 'FREE',
  PriceLevel.INEXPENSIVE: 'INEXPENSIVE',
  PriceLevel.MODERATE: 'MODERATE',
  PriceLevel.EXPENSIVE: 'EXPENSIVE',
  PriceLevel.VERY_EXPENSIVE: 'VERY_EXPENSIVE',
  PriceLevel.UNKNOWN: 'UNKNOWN',
  PriceLevel.PRICE_LEVEL_FREE: 'PRICE_LEVEL_FREE',
  PriceLevel.PRICE_LEVEL_INEXPENSIVE: 'PRICE_LEVEL_INEXPENSIVE',
  PriceLevel.PRICE_LEVEL_MODERATE: 'PRICE_LEVEL_MODERATE',
  PriceLevel.PRICE_LEVEL_EXPENSIVE: 'PRICE_LEVEL_EXPENSIVE',
  PriceLevel.PRICE_LEVEL_VERY_EXPENSIVE: 'PRICE_LEVEL_VERY_EXPENSIVE',
};
