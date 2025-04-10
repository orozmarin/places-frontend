import 'package:gastrorate/models/coordinates.dart';

class NearbyPlacesSearchForm {
  List<String> includedTypes;
  int maxResultCount;
  LocationRestriction locationRestriction;

  NearbyPlacesSearchForm({
    required this.includedTypes,
    required this.maxResultCount,
    required this.locationRestriction,
  });

  Map<String, dynamic> toJson() => {
        'includedTypes': includedTypes,
        'maxResultCount': maxResultCount,
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
