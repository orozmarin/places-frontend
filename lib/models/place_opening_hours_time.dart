import 'package:json_annotation/json_annotation.dart';

part 'place_opening_hours_time.g.dart';

@JsonSerializable(explicitToJson: true)
class PlaceOpeningHoursTime {
  int? day;
  String? time;

  factory PlaceOpeningHoursTime.fromJson(Map<String, dynamic> json) => _$PlaceOpeningHoursTimeFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceOpeningHoursTimeToJson(this);

  PlaceOpeningHoursTime({this.day, this.time});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaceOpeningHoursTime &&
          day == other.day &&
          time == other.time);

  @override
  int get hashCode => day.hashCode ^ time.hashCode;

  @override
  String toString() {
    return 'PlaceOpeningHoursTime{ day: $day, time: $time,}';
  }

  PlaceOpeningHoursTime copyWith({int? day, int? hours, int? minutes, String? time, int? nextDate}) {
    return PlaceOpeningHoursTime(
      day: day ?? this.day,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'time': time,
    };
  }

  factory PlaceOpeningHoursTime.fromMap(Map<String, dynamic> map) {
    return PlaceOpeningHoursTime(
      day: map['day'] as int?,
      time: map['time'] as String?,
    );
  }
}
