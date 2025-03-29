// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_opening_hours.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceOpeningHours _$PlaceOpeningHoursFromJson(Map<String, dynamic> json) =>
    PlaceOpeningHours(
      openNow: json['openNow'] as bool?,
      periods: (json['periods'] as List<dynamic>?)
          ?.map((e) =>
              PlaceOpeningHoursPeriod.fromJson(e as Map<String, dynamic>))
          .toList(),
      weekdayText: (json['weekdayText'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PlaceOpeningHoursToJson(PlaceOpeningHours instance) =>
    <String, dynamic>{
      'openNow': instance.openNow,
      'periods': instance.periods?.map((e) => e.toJson()).toList(),
      'weekdayText': instance.weekdayText,
    };
