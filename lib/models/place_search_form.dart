import 'package:json_annotation/json_annotation.dart';
part 'place_search_form.g.dart';

@JsonSerializable(explicitToJson: true)
class PlaceSearchForm{
  PlaceSorting? sortingMethod;

  // Constructor

  factory PlaceSearchForm.fromJson(Map<String, dynamic> json) => _$PlaceSearchFormFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceSearchFormToJson(this);

//<editor-fold desc="Data Methods">
  PlaceSearchForm({
    this.sortingMethod,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is PlaceSearchForm &&
              runtimeType == other.runtimeType &&
              sortingMethod == other.sortingMethod);

  @override
  int get hashCode => sortingMethod.hashCode;

  @override
  String toString() {
    return 'Rating{' +
        ' sortingMethod: $sortingMethod,'
        '}';
  }

  PlaceSearchForm copyWith({
    PlaceSorting? sortingMethod,
  }) {
    return PlaceSearchForm(
      sortingMethod: sortingMethod ?? this.sortingMethod,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sortingMethod': sortingMethod,
    };
  }

  factory PlaceSearchForm.fromMap(Map<String, dynamic> map) {
    return PlaceSearchForm(
      sortingMethod: map['sortingMethod'] as PlaceSorting,
    );
  }
}

enum PlaceSorting {
  ALPHABETICALLY_ASC,
  ALPHABETICALLY_DESC,
  RATING_ASC,
  RATING_DESC,
  DATE_ASC,
  DATE_DESC
}