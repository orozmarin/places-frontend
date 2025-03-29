// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'places_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlacesState _$PlacesStateFromJson(Map<String, dynamic> json) => PlacesState(
      places: (json['places'] as List<dynamic>?)
          ?.map((e) => Place.fromJson(e as Map<String, dynamic>))
          .toList(),
      place: json['place'] == null
          ? null
          : Place.fromJson(json['place'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlacesStateToJson(PlacesState instance) =>
    <String, dynamic>{
      'places': instance.places?.map((e) => e.toJson()).toList(),
      'place': instance.place?.toJson(),
    };
