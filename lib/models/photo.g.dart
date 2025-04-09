// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Photo _$PhotoFromJson(Map<String, dynamic> json) => Photo(
      photoReference: json['photoReference'] as String?,
      height: (json['height'] as num?)?.toInt(),
      width: (json['width'] as num?)?.toInt(),
      htmlAttributions: (json['htmlAttributions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Photo _$PhotoFromGoogleJson(Map<String, dynamic> json) {
  return Photo(
    photoReference: (json['name'] as String?)?.split('/').last,
    height: (json['heightPx'] as num?)?.toInt(),
    width: (json['widthPx'] as num?)?.toInt(),
    htmlAttributions: (json['authorAttributions'] as List<dynamic>?)
        ?.map((e) => e['displayName'] as String? ?? '')
        .where((e) => e.isNotEmpty)
        .toList(),
  );
}

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'photoReference': instance.photoReference,
      'height': instance.height,
      'width': instance.width,
      'htmlAttributions': instance.htmlAttributions,
    };
