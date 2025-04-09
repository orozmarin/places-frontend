import 'package:gastrorate/models/coordinates.dart';
import 'package:gastrorate/models/photo.dart';
import 'package:gastrorate/models/place_opening_hours.dart';
import 'package:gastrorate/models/place_opening_hours_period.dart';
import 'package:gastrorate/models/place_opening_hours_time.dart';
import 'package:gastrorate/models/place_review.dart';
import 'package:gastrorate/models/price_level.dart';
import 'package:gastrorate/models/rating.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:html/dom.dart';
import 'package:json_annotation/json_annotation.dart';

part 'place.g.dart';

@JsonSerializable(explicitToJson: true)
class Place {
  String? id;
  String? name;
  String? address;
  String? city;
  int? postalCode;
  String? country;
  String? contactNumber;
  PlaceOpeningHours? openingHours;
  List<Photo>? photos;
  PriceLevel? priceLevel;
  List<PlaceReview>? reviews;
  double? googleRating;
  String? url;
  String? webSiteUrl;
  Coordinates? coordinates;
  Rating? firstRating;
  Rating? secondRating;
  double? placeRating;
  DateTime? visitedAt;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);

  factory Place.fromGoogleJson(Map<String, dynamic> json) => _$PlaceFromGoogleJson(json);
  Map<String, dynamic> toJson() => _$PlaceToJson(this);

  Place({
    this.id,
    this.name,
    this.address,
    this.city,
    this.postalCode,
    this.country,
    this.contactNumber,
    this.openingHours,
    this.photos,
    this.priceLevel,
    this.reviews,
    this.googleRating,
    this.url,
    this.webSiteUrl,
    this.coordinates,
    this.firstRating,
    this.secondRating,
    this.placeRating,
    this.visitedAt,
  });

  factory Place.fromPickResult(PickResult result) {
    var document = Document.html(result.adrAddress ?? "");

    return Place(
      address: document.querySelector('.street-address')?.text ?? '',
      postalCode: int.tryParse(document.querySelector('.postal-code')?.text ?? ''),
      city: document.querySelector('.locality')?.text ?? '',
      country: document.querySelector('.country-name')?.text ?? '',
      name: result.name,
      contactNumber: result.internationalPhoneNumber,
      googleRating: result.rating as double?,
      url: result.url,
      webSiteUrl: result.website,
      photos: result.photos
          ?.map((photo) => Photo(
        photoReference: photo.photoReference,
        height: photo.height as int,
        width: photo.width as int,
        htmlAttributions: photo.htmlAttributions,
      ))
          .toList(),
      reviews: result.reviews
          ?.map((review) => PlaceReview(
        text: review.text,
        authorName: review.authorName,
        authorUrl: review.authorUrl,
        language: review.language,
        profilePhotoUrl: review.profilePhotoUrl,
        rating: review.rating as int,
        relativeTimeDescription: review.relativeTimeDescription,
        time: review.time as int,
      ))
          .toList(),
      openingHours: result.openingHours == null
          ? null
          : PlaceOpeningHours(
        openNow: result.openingHours?.openNow,
        weekdayText: result.openingHours?.weekdayText,
        periods: result.openingHours?.periods
            .map((e) => PlaceOpeningHoursPeriod(
          open: PlaceOpeningHoursTime(time: e.open?.time, day: e.open?.day),
          close: PlaceOpeningHoursTime(time: e.close?.time, day: e.close?.day),
        ))
            .toList(),
      ),
      coordinates: Coordinates(latitude: result.geometry?.location.lat, longitude: result.geometry?.location.lng),
      priceLevel: convertPriceLevelByName(result.priceLevel?.name),
      visitedAt: DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Place &&
              id == other.id &&
              name == other.name &&
              address == other.address &&
              city == other.city &&
              postalCode == other.postalCode &&
              country == other.country &&
          contactNumber == other.contactNumber &&
          openingHours == other.openingHours &&
          photos == other.photos &&
          priceLevel == other.priceLevel &&
          reviews == other.reviews &&
          googleRating == other.googleRating &&
          url == other.url &&
          webSiteUrl == other.webSiteUrl &&
          coordinates == other.coordinates &&
          firstRating == other.firstRating &&
              secondRating == other.secondRating &&
              placeRating == other.placeRating &&
          visitedAt == other.visitedAt);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      address.hashCode ^
      city.hashCode ^
      postalCode.hashCode ^
      country.hashCode ^
      contactNumber.hashCode ^
      openingHours.hashCode ^
      photos.hashCode ^
      priceLevel.hashCode ^
      reviews.hashCode ^
      googleRating.hashCode ^
      url.hashCode ^
      webSiteUrl.hashCode ^
      firstRating.hashCode ^
      secondRating.hashCode ^
      placeRating.hashCode ^
      coordinates.hashCode ^
      visitedAt.hashCode;

  @override
  String toString() {
    return 'Place{ id: $id, name: $name, address: $address, city: $city, postalCode: $postalCode, country: $country, contactNumber: $contactNumber, openingHours: $openingHours, photos: $photos, priceLevel: $priceLevel, reviews: $reviews, googleRating: $googleRating, url: $url, webSiteUrl: $webSiteUrl, coordinates: $coordinates, firstRating: $firstRating, secondRating: $secondRating, placeRating: $placeRating, visitedAt: $visitedAt }';
  }

  Place copyWith({
    String? id,
    String? name,
    String? address,
    String? city,
    int? postalCode,
    String? country,
    String? contactNumber,
    PlaceOpeningHours? openingHours,
    List<Photo>? photos,
    PriceLevel? priceLevel,
    List<PlaceReview>? reviews,
    double? googleRating,
    String? url,
    String? webSiteUrl,
    Coordinates? coordinates,
    Rating? firstRating,
    Rating? secondRating,
    double? placeRating,
    DateTime? visitedAt,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      contactNumber: contactNumber ?? this.contactNumber,
      openingHours: openingHours ?? this.openingHours,
      photos: photos ?? this.photos,
      priceLevel: priceLevel ?? this.priceLevel,
      reviews: reviews ?? this.reviews,
      googleRating: googleRating ?? this.googleRating,
      url: url ?? this.url,
      webSiteUrl: webSiteUrl ?? this.webSiteUrl,
      coordinates: coordinates ?? this.coordinates,
      firstRating: firstRating ?? this.firstRating,
      secondRating: secondRating ?? this.secondRating,
      placeRating: placeRating ?? this.placeRating,
      visitedAt: visitedAt ?? this.visitedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'postalCode': postalCode,
      'country': country,
      'contactNumber': contactNumber,
      'openingHours': openingHours?.toMap(),
      'photos': photos?.map((photo) => photo.toMap()).toList(),
      'priceLevel': priceLevel?.toString(),
      'reviews': reviews?.map((review) => review.toMap()).toList(),
      'googleRating': googleRating,
      'url': url,
      'webSiteUrl': webSiteUrl,
      'coordinates': coordinates,
      'firstRating': firstRating?.toMap(),
      'secondRating': secondRating?.toMap(),
      'placeRating': placeRating,
      'visitedAt': visitedAt?.toIso8601String(),
    };
  }

  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      id: map['id'] as String?,
      name: map['name'] as String?,
      address: map['address'] as String?,
      city: map['city'] as String?,
      postalCode: map['postalCode'] as int?,
      country: map['country'] as String?,
      contactNumber: map['contactNumber'] as String?,
      openingHours: map['openingHours'] != null ? PlaceOpeningHours.fromMap(map['openingHours']) : null,
      photos: map['photos'] != null ? List<Photo>.from(map['photos'].map((x) => Photo.fromMap(x))) : null,
      priceLevel:
          map['priceLevel'] != null ? PriceLevel.values.firstWhere((e) => e.toString() == map['priceLevel']) : null,
      reviews:
          map['reviews'] != null ? List<PlaceReview>.from(map['reviews'].map((x) => PlaceReview.fromMap(x))) : null,
      googleRating: map['googleRating'] as double?,
      url: map['url'] as String?,
      webSiteUrl: map['webSiteUrl'] as String?,
      coordinates: map['coordinates'] != null ? Coordinates.fromMap(map['coordinates']) : null,
      firstRating: map['firstRating'] != null ? Rating.fromMap(map['firstRating']) : null,
      secondRating: map['secondRating'] != null ? Rating.fromMap(map['secondRating']) : null,
      placeRating: map['placeRating'] as double?,
      visitedAt: map['visitedAt'] != null ? DateTime.parse(map['visitedAt']) : null,
    );
  }
}