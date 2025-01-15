import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

// a LocalDateTime already in user zone is returned from the server so no need to work with zone offsets
class CustomLocalDateTimeConverter implements JsonConverter<DateTime?, String?> {
  const CustomLocalDateTimeConverter();

  static const String ISO_LOCAL_DATE_TIME = "yyyy-MM-dd'T'HH:mm:ss";

  @override
  DateTime? fromJson(String? json) {
    return (json == null) ? null : DateTime.parse(json);
  }

  @override
  String? toJson(DateTime? dateTime) {
    return (dateTime == null) ? null : DateFormat(ISO_LOCAL_DATE_TIME).format(dateTime);
  }
}
