import 'package:json_annotation/json_annotation.dart';

part 'photo.g.dart';

@JsonSerializable(explicitToJson: true)
class Photo {
  String? photoReference;
  int? height;
  int? width;
  List<String>? htmlAttributions;

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);

  factory Photo.fromGoogleJson(Map<String, dynamic> json) => _$PhotoFromGoogleJson(json);
  Map<String, dynamic> toJson() => _$PhotoToJson(this);

  Photo({this.photoReference, this.height, this.width, this.htmlAttributions});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Photo &&
              photoReference == other.photoReference &&
              height == other.height &&
              width == other.width &&
              htmlAttributions == other.htmlAttributions);

  @override
  int get hashCode =>
      photoReference.hashCode ^ height.hashCode ^ width.hashCode ^ htmlAttributions.hashCode;

  @override
  String toString() {
    return 'Photo{ photoReference: $photoReference, height: $height, width: $width, htmlAttributions: $htmlAttributions }';
  }

  Photo copyWith({
    String? photoReference,
    int? height,
    int? width,
    List<String>? htmlAttributions,
  }) {
    return Photo(
      photoReference: photoReference ?? this.photoReference,
      height: height ?? this.height,
      width: width ?? this.width,
      htmlAttributions: htmlAttributions ?? this.htmlAttributions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'photoReference': photoReference,
      'height': height,
      'width': width,
      'htmlAttributions': htmlAttributions,
    };
  }

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      photoReference: map['photoReference'] as String?,
      height: map['height'] as int?,
      width: map['width'] as int?,
      htmlAttributions: map['htmlAttributions'] != null ? List<String>.from(map['htmlAttributions']) : null,
    );
  }
}
