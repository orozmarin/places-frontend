// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Place _$PlaceFromJson(Map<String, dynamic> json) => Place(
      id: json['id'] as String?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      postalCode: (json['postalCode'] as num?)?.toInt(),
      country: json['country'] as String?,
      contactNumber: json['contactNumber'] as String?,
      openingHours: json['openingHours'] == null
          ? null
          : PlaceOpeningHours.fromJson(
              json['openingHours'] as Map<String, dynamic>),
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
      firstRating: json['firstRating'] == null
          ? null
          : Rating.fromJson(json['firstRating'] as Map<String, dynamic>),
      secondRating: json['secondRating'] == null
          ? null
          : Rating.fromJson(json['secondRating'] as Map<String, dynamic>),
      placeRating: (json['placeRating'] as num?)?.toDouble(),
      visitedAt: json['visitedAt'] == null
          ? null
          : DateTime.parse(json['visitedAt'] as String),
    );

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
      'id': instance.id,
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
      'firstRating': instance.firstRating?.toJson(),
      'secondRating': instance.secondRating?.toJson(),
      'placeRating': instance.placeRating,
      'visitedAt': instance.visitedAt?.toIso8601String(),
    };

const _$PriceLevelEnumMap = {
  PriceLevel.FREE: 'FREE',
  PriceLevel.INEXPENSIVE: 'INEXPENSIVE',
  PriceLevel.MODERATE: 'MODERATE',
  PriceLevel.EXPENSIVE: 'EXPENSIVE',
  PriceLevel.VERY_EXPENSIVE: 'VERY_EXPENSIVE',
  PriceLevel.UNKNOWN: 'UNKNOWN',
};
