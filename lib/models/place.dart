import 'package:gastrorate/models/co_visitor.dart';
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
  String? userId;
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
  Rating? rating;
  List<CoVisitor>? coVisitors;
  DateTime? visitedAt;
  bool? isFavorite;
  double? distance;
  @JsonKey(includeToJson: false)
  String? visitId;
  @JsonKey(includeToJson: false)
  String? ownershipTransferredFromName;
  @JsonKey(includeToJson: false)
  DateTime? ownershipTransferredAt;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);

  factory Place.fromGoogleJson(Map<String, dynamic> json) {
    const priceLevelMap = {
      'FREE': PriceLevel.FREE,
      'INEXPENSIVE': PriceLevel.INEXPENSIVE,
      'MODERATE': PriceLevel.MODERATE,
      'EXPENSIVE': PriceLevel.EXPENSIVE,
      'VERY_EXPENSIVE': PriceLevel.VERY_EXPENSIVE,
      'UNKNOWN': PriceLevel.UNKNOWN,
      'PRICE_LEVEL_FREE': PriceLevel.PRICE_LEVEL_FREE,
      'PRICE_LEVEL_INEXPENSIVE': PriceLevel.PRICE_LEVEL_INEXPENSIVE,
      'PRICE_LEVEL_MODERATE': PriceLevel.PRICE_LEVEL_MODERATE,
      'PRICE_LEVEL_EXPENSIVE': PriceLevel.PRICE_LEVEL_EXPENSIVE,
      'PRICE_LEVEL_VERY_EXPENSIVE': PriceLevel.PRICE_LEVEL_VERY_EXPENSIVE,
    };
    return Place(
      id: json['id'] ?? (json['name'] as String?)?.split('/').last,
      name: json['displayName']?['text'] ?? json['name'],
      address: json['formattedAddress'] as String?,
      city: (json['addressComponents'] as List?)
          ?.firstWhere(
            (comp) => (comp['types'] as List?)?.contains('locality') ?? false,
            orElse: () => null,
          )?['longText'] as String?,
      postalCode: int.tryParse(
        (json['addressComponents'] as List?)
                ?.firstWhere(
                  (comp) => (comp['types'] as List?)?.contains('postal_code') ?? false,
                  orElse: () => null,
                )?['longText'] ??
            '',
      ),
      country: (json['addressComponents'] as List?)
          ?.firstWhere(
            (comp) => (comp['types'] as List?)?.contains('country') ?? false,
            orElse: () => null,
          )?['longText'] as String?,
      contactNumber: json['internationalPhoneNumber'] as String?,
      openingHours: json['regularOpeningHours'] == null
          ? null
          : PlaceOpeningHours.fromJson(json['regularOpeningHours'] as Map<String, dynamic>),
      photos: (json['photos'] as List?)
          ?.map((e) => Photo.fromGoogleJson(e as Map<String, dynamic>))
          .toList(),
      priceLevel: priceLevelMap[json['priceLevel'] as String?],
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => PlaceReview.fromGoogleJson(e as Map<String, dynamic>))
          .toList(),
      googleRating: (json['rating'] as num?)?.toDouble(),
      url: json['googleMapsUri'] as String?,
      webSiteUrl: json['websiteUri'] as String?,
      coordinates: json['location'] == null
          ? null
          : Coordinates(
              latitude: (json['location']['latitude'] as num?)?.toDouble(),
              longitude: (json['location']['longitude'] as num?)?.toDouble(),
            ),
      isFavorite: false,
      distance: null,
    );
  }
  Map<String, dynamic> toJson() => _$PlaceToJson(this);

  Place({
    this.id,
    this.userId,
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
    this.rating,
    this.coVisitors,
    this.visitedAt,
    this.isFavorite,
    this.distance,
    this.visitId,
    this.ownershipTransferredFromName,
    this.ownershipTransferredAt,
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
      isFavorite: false,
      distance: null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Place &&
              id == other.id &&
              userId == other.userId &&
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
              rating == other.rating &&
              coVisitors == other.coVisitors &&
              visitedAt == other.visitedAt &&
              isFavorite == other.isFavorite &&
              distance == other.distance &&
              visitId == other.visitId &&
              ownershipTransferredFromName == other.ownershipTransferredFromName &&
              ownershipTransferredAt == other.ownershipTransferredAt);

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
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
      rating.hashCode ^
      coVisitors.hashCode ^
      coordinates.hashCode ^
      visitedAt.hashCode ^
      isFavorite.hashCode ^
      distance.hashCode ^
      visitId.hashCode ^
      ownershipTransferredFromName.hashCode ^
      ownershipTransferredAt.hashCode;

  @override
  String toString() {
    return 'Place{ id: $id, userId: $userId, name: $name, address: $address, city: $city, postalCode: $postalCode, country: $country, contactNumber: $contactNumber, openingHours: $openingHours, photos: $photos, priceLevel: $priceLevel, reviews: $reviews, googleRating: $googleRating, url: $url, webSiteUrl: $webSiteUrl, coordinates: $coordinates, rating: $rating, coVisitors: $coVisitors, visitedAt: $visitedAt, isFavorite: $isFavorite, distance: $distance, visitId: $visitId, ownershipTransferredFromName: $ownershipTransferredFromName, ownershipTransferredAt: $ownershipTransferredAt }';
  }

  Place copyWith({
    String? id,
    String? userId,
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
    Rating? rating,
    List<CoVisitor>? coVisitors,
    DateTime? visitedAt,
    bool? isFavorite,
    double? distance,
    String? visitId,
    String? ownershipTransferredFromName,
    DateTime? ownershipTransferredAt,
  }) {
    return Place(
      id: id ?? this.id,
      userId: userId ?? this.userId,
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
      rating: rating ?? this.rating,
      coVisitors: coVisitors ?? this.coVisitors,
      visitedAt: visitedAt ?? this.visitedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      distance: distance ?? this.distance,
      visitId: visitId ?? this.visitId,
      ownershipTransferredFromName: ownershipTransferredFromName ?? this.ownershipTransferredFromName,
      ownershipTransferredAt: ownershipTransferredAt ?? this.ownershipTransferredAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
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
      'rating': rating?.toMap(),
      'coVisitors': coVisitors?.map((v) => v.toMap()).toList(),
      'visitedAt': visitedAt?.toIso8601String(),
      'isFavorite': isFavorite,
      'distance': distance,
      'visitId': visitId,
      'ownershipTransferredFromName': ownershipTransferredFromName,
      'ownershipTransferredAt': ownershipTransferredAt?.toIso8601String(),
    };
  }

  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      id: map['id'] as String?,
      userId: map['userId'] as String?,
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
      rating: map['rating'] != null ? Rating.fromMap(map['rating']) : null,
      coVisitors: map['coVisitors'] != null
          ? List<CoVisitor>.from(map['coVisitors'].map((x) => CoVisitor.fromMap(x)))
          : null,
      visitedAt: map['visitedAt'] != null ? DateTime.parse(map['visitedAt']) : null,
      isFavorite: map['isFavorite'] as bool?,
      distance: map['distance'] as double?,
      visitId: map['visitId'] as String?,
      ownershipTransferredFromName: map['ownershipTransferredFromName'] as String?,
      ownershipTransferredAt: map['ownershipTransferredAt'] != null
          ? DateTime.parse(map['ownershipTransferredAt'])
          : null,
    );
  }
}
