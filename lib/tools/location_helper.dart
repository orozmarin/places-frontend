import 'package:gastrorate/models/coordinates.dart';
import 'package:gastrorate/models/nearby_places_search_form.dart';
import 'package:geolocator/geolocator.dart';

class LocationHelper {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    // Request permission if it's denied
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }
    // If permission is denied forever
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permission.');
    }
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    // At this point, permissions are granted
    Position location = await Geolocator.getCurrentPosition();
    return location;
  }

  Future<NearbyPlacesSearchForm> getNearbyPlacesSearchForm() async {
    Coordinates? initialPosition;
    await LocationHelper()
        .getCurrentLocation()
        .then((value) => initialPosition = Coordinates(latitude: value.latitude, longitude: value.longitude));
    return NearbyPlacesSearchForm(
      includedTypes: ['restaurant'],
      maxResultCount: 10,
      locationRestriction: LocationRestriction(
        circle: Circle(
          center: initialPosition!,
          radius: 10000.0,
        ),
      ),
    );
  }

  Future<double?> getDistance(Coordinates placeCoords) async {
    Position currentLocation = await getCurrentLocation();
    if (placeCoords.latitude == null || placeCoords.longitude == null) {
      return null;
    }
    return Geolocator.distanceBetween(
        placeCoords.latitude!, placeCoords.longitude!, currentLocation.latitude, currentLocation.longitude);
  }
}
