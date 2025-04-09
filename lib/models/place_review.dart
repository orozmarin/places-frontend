import 'package:json_annotation/json_annotation.dart';

part 'place_review.g.dart';

@JsonSerializable(explicitToJson: true)
class PlaceReview {
  String? authorName;
  String? authorUrl;
  String? language;
  String? profilePhotoUrl;
  int? rating;
  String? relativeTimeDescription;
  String? text;
  int? time;

  factory PlaceReview.fromJson(Map<String, dynamic> json) => _$PlaceReviewFromJson(json);

  factory PlaceReview.fromGoogleJson(Map<String, dynamic> json) => _$PlaceReviewFromGoogleJson(json);
  Map<String, dynamic> toJson() => _$PlaceReviewToJson(this);

  PlaceReview({
    this.authorName,
    this.authorUrl,
    this.language,
    this.profilePhotoUrl,
    this.rating,
    this.relativeTimeDescription,
    this.text,
    this.time,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is PlaceReview &&
              authorName == other.authorName &&
              authorUrl == other.authorUrl &&
              language == other.language &&
              profilePhotoUrl == other.profilePhotoUrl &&
              rating == other.rating &&
              relativeTimeDescription == other.relativeTimeDescription &&
              text == other.text &&
              time == other.time);

  @override
  int get hashCode =>
      authorName.hashCode ^
      authorUrl.hashCode ^
      language.hashCode ^
      profilePhotoUrl.hashCode ^
      rating.hashCode ^
      relativeTimeDescription.hashCode ^
      text.hashCode ^
      time.hashCode;

  @override
  String toString() {
    return 'PlaceReview{ authorName: $authorName, authorUrl: $authorUrl, language: $language, profilePhotoUrl: $profilePhotoUrl, rating: $rating, relativeTimeDescription: $relativeTimeDescription, text: $text, time: $time }';
  }

  PlaceReview copyWith({
    String? authorName,
    String? authorUrl,
    String? language,
    String? profilePhotoUrl,
    int? rating,
    String? relativeTimeDescription,
    String? text,
    int? time,
  }) {
    return PlaceReview(
      authorName: authorName ?? this.authorName,
      authorUrl: authorUrl ?? this.authorUrl,
      language: language ?? this.language,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      rating: rating ?? this.rating,
      relativeTimeDescription: relativeTimeDescription ?? this.relativeTimeDescription,
      text: text ?? this.text,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'authorName': authorName,
      'authorUrl': authorUrl,
      'language': language,
      'profilePhotoUrl': profilePhotoUrl,
      'rating': rating,
      'relativeTimeDescription': relativeTimeDescription,
      'text': text,
      'time': time,
    };
  }

  factory PlaceReview.fromMap(Map<String, dynamic> map) {
    return PlaceReview(
      authorName: map['authorName'] as String?,
      authorUrl: map['authorUrl'] as String?,
      language: map['language'] as String?,
      profilePhotoUrl: map['profilePhotoUrl'] as String?,
      rating: map['rating'] as int?,
      relativeTimeDescription: map['relativeTimeDescription'] as String?,
      text: map['text'] as String?,
      time: map['time'] as int?,
    );
  }
}