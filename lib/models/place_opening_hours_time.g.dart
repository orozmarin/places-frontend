// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_opening_hours_time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceOpeningHoursTime _$PlaceOpeningHoursTimeFromJson(
        Map<String, dynamic> json) =>
    PlaceOpeningHoursTime(
      day: (json['day'] as num?)?.toInt(),
      time: json['time'] as String?,
    );

Map<String, dynamic> _$PlaceOpeningHoursTimeToJson(
        PlaceOpeningHoursTime instance) =>
    <String, dynamic>{
      'day': instance.day,
      'time': instance.time,
    };
