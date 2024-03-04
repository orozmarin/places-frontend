// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurants_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantsState _$RestaurantsStateFromJson(Map<String, dynamic> json) =>
    RestaurantsState(
      restaurants: (json['restaurants'] as List<dynamic>?)
          ?.map((e) => Restaurant.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentRestaurant: json['currentRestaurant'] == null
          ? null
          : Restaurant.fromJson(
              json['currentRestaurant'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RestaurantsStateToJson(RestaurantsState instance) =>
    <String, dynamic>{
      'restaurants': instance.restaurants?.map((e) => e.toJson()).toList(),
      'currentRestaurant': instance.currentRestaurant?.toJson(),
    };
