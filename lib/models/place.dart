import 'package:gastrorate/models/rating.dart';
import 'package:gastrorate/tools/custom_local_date_converter.dart';
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
  Rating? firstRating;
  Rating? secondRating;
  double? placeRating;
  DateTime? visitedAt;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceToJson(this);

//<editor-fold desc="Data Methods">

  Place({
    this.id,
    this.name,
    this.address,
    this.city,
    this.postalCode,
    this.country,
    this.firstRating,
    this.secondRating,
    this.placeRating,
    this.visitedAt,
  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Place &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              address == other.address &&
              city == other.city &&
              postalCode == other.postalCode &&
              country == other.country &&
              firstRating == other.firstRating &&
              secondRating == other.secondRating &&
              placeRating == other.placeRating &&
              visitedAt == other.visitedAt
          );


  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      address.hashCode ^
      city.hashCode ^
      postalCode.hashCode ^
      country.hashCode ^
      firstRating.hashCode ^
      secondRating.hashCode ^
      placeRating.hashCode ^
      visitedAt.hashCode;


  @override
  String toString() {
    return 'Place{' +
        ' id: $id,' +
        ' name: $name,' +
        ' address: $address,' +
        ' city: $city,' +
        ' postalCode: $postalCode,' +
        ' country: $country,' +
        ' firstRating: $firstRating,' +
        ' secondRating: $secondRating,' +
        ' placeRating: $placeRating,' +
        ' visitedAt: $visitedAt,' +
        '}';
  }


  Place copyWith({
    String? id,
    String? name,
    String? address,
    String? city,
    int? postalCode,
    String? country,
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
      firstRating: firstRating ?? this.firstRating,
      secondRating: secondRating ?? this.secondRating,
      placeRating: placeRating ?? this.placeRating,
      visitedAt: visitedAt ?? this.visitedAt,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'address': this.address,
      'city': this.city,
      'postalCode': this.postalCode,
      'country': this.country,
      'firstRating': this.firstRating,
      'secondRating': this.secondRating,
      'placeRating': this.placeRating,
      'visitedAt': this.visitedAt,
    };
  }

  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      id: map['id'] as String,
      name: map['name'] as String,
      address: map['address'] as String,
      city: map['city'] as String,
      postalCode: map['postalCode'] as int,
      country: map['country'] as String,
      firstRating: map['firstRating'] as Rating,
      secondRating: map['secondRating'] as Rating,
      placeRating: map['placeRating'] as double,
      visitedAt: map['visitedAt'] as DateTime,
    );
  }


//</editor-fold>
}