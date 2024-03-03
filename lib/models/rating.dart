import 'package:json_annotation/json_annotation.dart';

part 'rating.g.dart';

@JsonSerializable(explicitToJson: true)
class Rating {
  final double ambientRating;
  final double foodRating;
  final double priceRating;
  final double restaurantRating;

  // Constructor

  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);

  Map<String, dynamic> toJson() => _$RatingToJson(this);

//<editor-fold desc="Data Methods">
  const Rating({
    required this.ambientRating,
    required this.foodRating,
    required this.priceRating,
    required this.restaurantRating,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Rating &&
          runtimeType == other.runtimeType &&
          ambientRating == other.ambientRating &&
          foodRating == other.foodRating &&
          priceRating == other.priceRating &&
          restaurantRating == other.restaurantRating);

  @override
  int get hashCode => ambientRating.hashCode ^ foodRating.hashCode ^ priceRating.hashCode ^ restaurantRating.hashCode;

  @override
  String toString() {
    return 'Rating{' +
        ' ambientRating: $ambientRating,' +
        ' foodRating: $foodRating,' +
        ' priceRating: $priceRating,' +
        ' restaurantRating: $restaurantRating,' +
        '}';
  }

  Rating copyWith({
    double? ambientRating,
    double? foodRating,
    double? priceRating,
    double? restaurantRating,
  }) {
    return Rating(
      ambientRating: ambientRating ?? this.ambientRating,
      foodRating: foodRating ?? this.foodRating,
      priceRating: priceRating ?? this.priceRating,
      restaurantRating: restaurantRating ?? this.restaurantRating,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ambientRating': this.ambientRating,
      'foodRating': this.foodRating,
      'priceRating': this.priceRating,
      'restaurantRating': this.restaurantRating,
    };
  }

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      ambientRating: map['ambientRating'] as double,
      foodRating: map['foodRating'] as double,
      priceRating: map['priceRating'] as double,
      restaurantRating: map['restaurantRating'] as double,
    );
  }

//</editor-fold>
}