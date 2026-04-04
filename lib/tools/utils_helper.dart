import 'package:flutter_dotenv/flutter_dotenv.dart';

class UtilsHelper {
  /// Resolves a potentially relative image URL (e.g. /uploads/...) to a full URL
  /// by prepending the server base derived from API_BASE_URI in .env.
  static String resolveImageUrl(String url) {
    if (url.startsWith('/')) {
      final apiBase = dotenv.env['API_BASE_URI'] ?? '';
      final serverBase = apiBase.endsWith('/rest')
          ? apiBase.substring(0, apiBase.length - 5)
          : apiBase;
      return '$serverBase$url';
    }
    return url;
  }
  static String extractFirstLetter(String name) {
    if (name.isNotEmpty) {
      return name[0];
    }
    return '';
  }

  /// Formats a rating value without unnecessary decimals.
  /// 8.0 → "8", 8.5 → "8.5"
  static String formatRating(double? v) {
    if (v == null) return '?';
    return v % 1 == 0 ? v.toInt().toString() : v.toStringAsFixed(1);
  }
}