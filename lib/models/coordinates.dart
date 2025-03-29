import 'package:json_annotation/json_annotation.dart';

part 'coordinates.g.dart';

@JsonSerializable(explicitToJson: true)
class Coordinates {
  double? latitude;
  double? longitude;

  factory Coordinates.fromJson(Map<String, dynamic> json) => _$CoordinatesFromJson(json);
  Map<String, dynamic> toJson() => _$CoordinatesToJson(this);

  Coordinates({this.latitude, this.longitude});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Coordinates &&
              latitude == other.latitude &&
              longitude == other.longitude);

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() {
    return 'Coordinates{ latitude: $latitude, longitude: $longitude }';
  }

  Coordinates copyWith({
    double? latitude,
    double? longitude,
  }) {
    return Coordinates(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Coordinates.fromMap(Map<String, dynamic> map) {
    return Coordinates(
      latitude: map['latitude'] as double?,
      longitude: map['longitude'] as double?,
    );
  }
}
