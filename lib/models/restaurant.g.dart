// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) => Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      postalCode: json['postalCode'] as int,
      country: json['country'] as String,
      firstRating: Rating.fromJson(json['firstRating'] as Map<String, dynamic>),
      secondRating: Rating.fromJson(json['secondRating'] as Map<String, dynamic>),
      restaurantRating: (json['restaurantRating'] as num).toDouble(),
    );

Map<String, dynamic> _$RestaurantToJson(Restaurant instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'city': instance.city,
      'postalCode': instance.postalCode,
      'country': instance.country,
      'firstRating': instance.firstRating!.toJson(),
      'secondRating': instance.secondRating!.toJson(),
      'restaurantRating': instance.restaurantRating,
    };
