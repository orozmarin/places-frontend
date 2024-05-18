import 'package:gastrorate/models/rating.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant.g.dart';

@JsonSerializable(explicitToJson: true)
class Restaurant {
  String? id;
  String? name;
  String? address;
  String? city;
  int? postalCode;
  String? country;
  Rating? firstRating;
  Rating? secondRating;
  double? restaurantRating;

  factory Restaurant.fromJson(Map<String, dynamic> json) => _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);

//<editor-fold desc="Data Methods">


  Restaurant({
    this.id,
    this.name,
    this.address,
    this.city,
    this.postalCode,
    this.country,
    this.firstRating,
    this.secondRating,
    this.restaurantRating,
  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Restaurant &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              address == other.address &&
              city == other.city &&
              postalCode == other.postalCode &&
              country == other.country &&
              firstRating == other.firstRating &&
              secondRating == other.secondRating &&
              restaurantRating == other.restaurantRating
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
      restaurantRating.hashCode;


  @override
  String toString() {
    return 'Restaurant{' +
        ' id: $id,' +
        ' name: $name,' +
        ' address: $address,' +
        ' city: $city,' +
        ' postalCode: $postalCode,' +
        ' country: $country,' +
        ' firstRating: $firstRating,' +
        ' secondRating: $secondRating,' +
        ' restaurantRating: $restaurantRating,' +
        '}';
  }


  Restaurant copyWith({
    String? id,
    String? name,
    String? address,
    String? city,
    int? postalCode,
    String? country,
    Rating? firstRating,
    Rating? secondRating,
    double? restaurantRating,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      firstRating: firstRating ?? this.firstRating,
      secondRating: secondRating ?? this.secondRating,
      restaurantRating: restaurantRating ?? this.restaurantRating,
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
      'restaurantRating': this.restaurantRating,
    };
  }

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['id'] as String,
      name: map['name'] as String,
      address: map['address'] as String,
      city: map['city'] as String,
      postalCode: map['postalCode'] as int,
      country: map['country'] as String,
      firstRating: map['firstRating'] as Rating,
      secondRating: map['secondRating'] as Rating,
      restaurantRating: map['restaurantRating'] as double,
    );
  }


//</editor-fold>
}