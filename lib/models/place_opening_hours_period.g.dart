// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_opening_hours_period.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceOpeningHoursPeriod _$PlaceOpeningHoursPeriodFromJson(
        Map<String, dynamic> json) =>
    PlaceOpeningHoursPeriod(
      open: json['open'] == null
          ? null
          : PlaceOpeningHoursTime.fromJson(
              json['open'] as Map<String, dynamic>),
      close: json['close'] == null
          ? null
          : PlaceOpeningHoursTime.fromJson(
              json['close'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlaceOpeningHoursPeriodToJson(
        PlaceOpeningHoursPeriod instance) =>
    <String, dynamic>{
      'open': instance.open?.toJson(),
      'close': instance.close?.toJson(),
    };
