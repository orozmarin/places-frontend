// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Place _$PlaceFromJson(Map<String, dynamic> json) => Place(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      postalCode: json['postalCode'] as int,
      country: json['country'] as String,
      firstRating: Rating.fromJson(json['firstRating'] as Map<String, dynamic>),
      secondRating: Rating.fromJson(json['secondRating'] as Map<String, dynamic>),
      placeRating: (json['placeRating'] as num).toDouble(),
      visitedAt: const CustomLocalDateTimeConverter().fromJson(json['visitedAt'] as String?),
    );

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'city': instance.city,
      'postalCode': instance.postalCode,
      'country': instance.country,
      'firstRating': instance.firstRating!.toJson(),
      'secondRating': instance.secondRating!.toJson(),
      'placeRating': instance.placeRating,
      'visitedAt': const CustomLocalDateTimeConverter().toJson(instance.visitedAt)
    };
