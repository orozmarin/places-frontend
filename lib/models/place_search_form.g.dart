part of 'place_search_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceSearchForm _$PlaceSearchFormFromJson(
    Map<String, dynamic> json) =>
    PlaceSearchForm(
      sortingMethod: $enumDecodeNullable(
          _$PlaceSortingEnumMap, json['sortingMethod']),
    );

Map<String, dynamic> _$PlaceSearchFormToJson(
    PlaceSearchForm instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('sortingMethod',
      _$PlaceSortingEnumMap[instance.sortingMethod]);
  return val;
}

const _$PlaceSortingEnumMap = {
  PlaceSorting.ALPHABETICALLY_ASC: 'ALPHABETICALLY_ASC',
  PlaceSorting.ALPHABETICALLY_DESC: 'ALPHABETICALLY_DESC',
  PlaceSorting.DATE_ASC: 'DATE_ASC',
  PlaceSorting.DATE_DESC: 'DATE_DESC',
  PlaceSorting.RATING_ASC: 'RATING_ASC',
  PlaceSorting.RATING_DESC: 'RATING_DESC',
};
