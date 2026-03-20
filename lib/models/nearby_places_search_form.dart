import 'package:gastrorate/models/coordinates.dart';

class NearbyPlacesSearchForm {
  List<String> includedPrimaryTypes;
  int maxResultCount;
  String rankPreference;
  LocationRestriction locationRestriction;

  NearbyPlacesSearchForm({
    required this.includedPrimaryTypes,
    required this.maxResultCount,
    this.rankPreference = 'DISTANCE',
    required this.locationRestriction,
  });

  Map<String, dynamic> toJson() => {
        'includedPrimaryTypes': includedPrimaryTypes,
        'maxResultCount': maxResultCount,
        'rankPreference': rankPreference,
        'locationRestriction': locationRestriction.toJson(),
      };
}

class LocationRestriction {
  Circle circle;

  LocationRestriction({required this.circle});

  Map<String, dynamic> toJson() => {
        'circle': circle.toJson(),
      };
}

class Circle {
  Coordinates center;
  double radius;

  Circle({required this.center, required this.radius});

  Map<String, dynamic> toJson() => {
        'center': {
          'latitude': center.latitude,
          'longitude': center.longitude,
        },
        'radius': radius,
      };
}
