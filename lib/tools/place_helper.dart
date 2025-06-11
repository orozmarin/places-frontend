import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/place_search_form.dart';

class PlaceHelper {
  static List<Place> sortPlaces(List<Place> places, PlaceSorting sorting) {
    final sorted = [...places];

    switch (sorting) {
      case PlaceSorting.ALPHABETICALLY_ASC:
        sorted.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
        break;
      case PlaceSorting.ALPHABETICALLY_DESC:
        sorted.sort((a, b) => (b.name ?? '').compareTo(a.name ?? ''));
        break;
      case PlaceSorting.RATING_ASC:
        sorted.sort((a, b) => (a.placeRating ?? 0).compareTo(b.placeRating ?? 0));
        break;
      case PlaceSorting.RATING_DESC:
        sorted.sort((a, b) => (b.placeRating ?? 0).compareTo(a.placeRating ?? 0));
        break;
      case PlaceSorting.DATE_ASC:
        sorted.sort((a, b) => (a.visitedAt ?? DateTime(0)).compareTo(b.visitedAt ?? DateTime(0)));
        break;
      case PlaceSorting.DATE_DESC:
        sorted.sort((a, b) => (b.visitedAt ?? DateTime(0)).compareTo(a.visitedAt ?? DateTime(0)));
        break;
    }

    return sorted;
  }
}
