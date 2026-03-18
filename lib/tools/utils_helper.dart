class UtilsHelper {
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