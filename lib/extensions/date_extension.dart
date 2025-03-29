import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension FormatDateToString on DateTime? {
  String formatDate({bool shortYears = false, bool noYears = false}) {
    if (this == null) return '';

    try {
      final format = noYears
          ? 'dd.MM.'
          : shortYears
              ? 'dd.MM.yy.'
              : 'dd.MM.yyyy.';

      return DateFormat(format).format(this!);
    } catch (e) {
      debugPrint('Error formatting dateTime: $e');
      return '';
    }
  }

  String formatDateToDayMonth() {
    if (this == null) return '';

    try {
      return DateFormat('dd MMM').format(this!);
    } catch (e) {
      debugPrint('Error formatting dateTime: $e');
      return '';
    }
  }

  String formatDateToDayMonthWithTime() {
    if (this == null) return '';

    try {
      return DateFormat('dd MMM. HH:mm').format(this!);
    } catch (e) {
      debugPrint('Error formatting dateTime: $e');
      return '';
    }
  }

  String writeTodayYesterdayOrDate({bool shortYears = false, bool noYears = false}) {
    if (this == null) return '';

    if (DateUtils.isSameDay(this, DateTime.now())) {
      return 'Today';
    }
    if (DateUtils.isSameDay(this, DateTime.now().subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    }
    return formatDate(shortYears: shortYears, noYears: noYears);
  }

  String formatDateToDateWithTime({bool shortYears = false}) {
    if (this == null) return '';

    try {
      final format = shortYears ? 'dd.MM.yy. HH:mm' : 'dd.MM.yyyy. HH:mm';
      return DateFormat(format).format(this!);
    } catch (e) {
      debugPrint('Error formatting dateTime: $e');
      return '';
    }
  }

  String formatDateToTimeOnly() {
    if (this == null) return '';

    try {
      return DateFormat.Hm().format(this!);
    } catch (e) {
      debugPrint('Error formatting dateTime: $e');
      return '';
    }
  }

  String formatDateToDay() {
    if (this == null) return '';

    try {
      return DateFormat('dd').format(this!);
    } catch (e) {
      debugPrint('Error formatting dateTime to day: $e');
      return '';
    }
  }

  String formatDateToMonth() {
    if (this == null) return '';

    try {
      return DateFormat('MMM').format(this!);
    } catch (e) {
      debugPrint('Error formatting dateTime to month: $e');
      return '';
    }
  }
}

extension DateTimeExtension on DateTime {
  DateTime getThisDateWithSysdateTime() {
    final sysdate = DateTime.now();
    return DateTime(
      sysdate.year,
      sysdate.month,
      sysdate.day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }

  DateTime roundToHour() => DateTime(year, month, day, hour);

  DateTime changeTo({required DateTime selectedDate, required bool leaveTimeAsIs}) {
    return leaveTimeAsIs
        ? DateTime(
            selectedDate.year, selectedDate.month, selectedDate.day, hour, minute, second, millisecond, microsecond)
        : DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedDate.hour, selectedDate.minute,
            selectedDate.second, selectedDate.millisecond, selectedDate.microsecond);
  }

  DateTime getThisDateWithHour(int hour) => DateTime(year, month, day, hour);
}
