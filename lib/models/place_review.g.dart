// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceReview _$PlaceReviewFromJson(Map<String, dynamic> json) => PlaceReview(
      authorName: json['authorName'] as String?,
      authorUrl: json['authorUrl'] as String?,
      language: json['language'] as String?,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      rating: (json['rating'] as num?)?.toInt(),
      relativeTimeDescription: json['relativeTimeDescription'] as String?,
      text: json['text'] as String?,
      time: (json['time'] as num?)?.toInt(),
    );

PlaceReview _$PlaceReviewFromGoogleJson(Map<String, dynamic> json) {
  final author = json['authorAttribution'] ?? {};
  final textBlock = json['text'] ?? {};

  return PlaceReview(
    authorName: author['displayName'] as String?,
    authorUrl: author['uri'] as String?,
    profilePhotoUrl: author['photoUri'] as String?,
    rating: json['rating'] as int?,
    relativeTimeDescription: json['relativePublishTimeDescription'] as String?,
    text: textBlock['text'] as String?,
    language: textBlock['languageCode'] as String?,
    time: DateTime.tryParse(json['publishTime'] ?? '')?.millisecondsSinceEpoch,
  );
}

Map<String, dynamic> _$PlaceReviewToJson(PlaceReview instance) =>
    <String, dynamic>{
      'authorName': instance.authorName,
      'authorUrl': instance.authorUrl,
      'language': instance.language,
      'profilePhotoUrl': instance.profilePhotoUrl,
      'rating': instance.rating,
      'relativeTimeDescription': instance.relativeTimeDescription,
      'text': instance.text,
      'time': instance.time,
    };
