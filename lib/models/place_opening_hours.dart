import 'package:gastrorate/models/place_opening_hours_period.dart';
import 'package:json_annotation/json_annotation.dart';

part 'place_opening_hours.g.dart';

@JsonSerializable(explicitToJson: true)
class PlaceOpeningHours {
  bool? openNow;
  List<PlaceOpeningHoursPeriod>? periods;
  List<String>? weekdayText;

  factory PlaceOpeningHours.fromJson(Map<String, dynamic> json) => _$PlaceOpeningHoursFromJson(json);
  Map<String, dynamic> toJson() => _$PlaceOpeningHoursToJson(this);

  PlaceOpeningHours({this.openNow, this.periods, this.weekdayText});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is PlaceOpeningHours &&
              openNow == other.openNow &&
              periods == other.periods &&
              weekdayText == other.weekdayText);

  @override
  int get hashCode => openNow.hashCode ^ periods.hashCode ^ weekdayText.hashCode;

  @override
  String toString() {
    return 'PlaceOpeningHours{ openNow: $openNow, periods: $periods, weekdayText: $weekdayText }';
  }

  PlaceOpeningHours copyWith({bool? openNow, List<PlaceOpeningHoursPeriod>? periods, List<String>? weekdayText}) {
    return PlaceOpeningHours(
      openNow: openNow ?? this.openNow,
      periods: periods ?? this.periods,
      weekdayText: weekdayText ?? this.weekdayText,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'openNow': openNow,
      'periods': periods?.map((e) => e.toMap()).toList(),
      'weekdayText': weekdayText,
    };
  }

  factory PlaceOpeningHours.fromMap(Map<String, dynamic> map) {
    return PlaceOpeningHours(
      openNow: map['openNow'] as bool?,
      periods: map['periods'] != null ? (map['periods'] as List).map((e) => PlaceOpeningHoursPeriod.fromMap(e)).toList() : null,
      weekdayText: map['weekdayText'] != null ? List<String>.from(map['weekdayText']) : null,
    );
  }
}