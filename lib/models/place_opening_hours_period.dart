import 'package:gastrorate/models/place_opening_hours_time.dart';
import 'package:json_annotation/json_annotation.dart';

part 'place_opening_hours_period.g.dart';

@JsonSerializable(explicitToJson: true)
class PlaceOpeningHoursPeriod {
  PlaceOpeningHoursTime? open;
  PlaceOpeningHoursTime? close;

  factory PlaceOpeningHoursPeriod.fromJson(Map<String, dynamic> json) => _$PlaceOpeningHoursPeriodFromJson(json);
  Map<String, dynamic> toJson() => _$PlaceOpeningHoursPeriodToJson(this);

  PlaceOpeningHoursPeriod({this.open, this.close});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is PlaceOpeningHoursPeriod &&
              open == other.open &&
              close == other.close);

  @override
  int get hashCode => open.hashCode ^ close.hashCode;

  @override
  String toString() {
    return 'PlaceOpeningHoursPeriod{ open: $open, close: $close }';
  }

  PlaceOpeningHoursPeriod copyWith({PlaceOpeningHoursTime? open, PlaceOpeningHoursTime? close}) {
    return PlaceOpeningHoursPeriod(
      open: open ?? this.open,
      close: close ?? this.close,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'open': open?.toMap(),
      'close': close?.toMap(),
    };
  }

  factory PlaceOpeningHoursPeriod.fromMap(Map<String, dynamic> map) {
    return PlaceOpeningHoursPeriod(
      open: map['open'] != null ? PlaceOpeningHoursTime.fromMap(map['open']) : null,
      close: map['close'] != null ? PlaceOpeningHoursTime.fromMap(map['close']) : null,
    );
  }
}