import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:intl/intl.dart';
import 'package:pain_app/i18n/translations.i18n.dart';
import 'package:pain_app/tools/safe_print.dart';

extension FormatDateToString on DateTime? {
  String formatDate({bool shortYears = false, bool noYears = false}) {
    if (this == null) {
      return '';
    } else {
      try {
        String format = '';
        if (shortYears) {
          format = 'dd.MM.yy.';
        } else if (noYears) {
          format = 'dd.MM.';
        } else {
          format = 'dd.MM.yyyy.';
        }
        DateFormat df = DateFormat(format, I18n.localeStr);
        String formattedDate = df.format(this!);
        return formattedDate;
      } catch (e) {
        savePrint('Error formatting dateTime: ' + e.toString());
        return '';
      }
    }
  }

  String formatDateToDayMonth() {
    if (this == null) {
      return '';
    } else {
      try {
        DateFormat df = DateFormat('dd MMM', I18n.localeStr);
        String formattedDate = df.format(this!);
        return formattedDate;
      } catch (e) {
        savePrint('Error formatting dateTime: ' + e.toString());
        return '';
      }
    }
  }

  String formatDateToDayMonthWithTime() {
    if (this == null) {
      return '';
    } else {
      try {
        DateFormat df = DateFormat('dd MMM. HH:mm', I18n.localeStr);
        String formattedDate = df.format(this!);
        return formattedDate;
      } catch (e) {
        savePrint('Error formatting dateTime: ' + e.toString());
        return '';
      }
    }
  }

  String writeTodayYesterdayOrDate({bool shortYears = false, bool noYears = false}) {
    if (this == null) {
      return '';
    } else {
      if (DateUtils.isSameDay(this, DateTime.now())) {
        return 'date.today'.i18n;
      } else if (DateUtils.isSameDay(this, DateTime.now().subtract(const Duration(days: 1)))) {
        return 'date.yesterday'.i18n;
      } else {
        return this.formatDate(shortYears: shortYears, noYears: noYears);
      }
    }
  }

  String formatDateToDateWithTime({bool shortYears = false}) {
    if (this == null) {
      return '';
    } else {
      try {
        DateFormat df = DateFormat(shortYears ? 'dd.MM.yy. HH:mm' : 'dd.MM.yyyy. HH:mm', I18n.localeStr);
        String formattedDate = df.format(this!);
        return formattedDate;
      } catch (e) {
        savePrint('Error formatting dateTime: ' + e.toString());
        return '';
      }
    }
  }

  String formatDateToTimeOnly() {
    if (this == null) {
      return '';
    } else {
      try {
        DateFormat df = DateFormat.Hm();
        String formattedDate = df.format(this!);
        return formattedDate;
      } catch (e) {
        savePrint('Error formatting dateTime: ' + e.toString());
        return '';
      }
    }
  }

  String formatDateToDay() {
    try {
      DateFormat df = DateFormat('dd', I18n.localeStr);
      return df.format(this!);
    } catch (e) {
      savePrint('Error formatting dateTime to day: ' + e.toString());
      return '';
    }
  }

  String formatDateToMonth() {
    try {
      DateFormat df = DateFormat('MMM', I18n.localeStr);
      return df.format(this!);
    } catch (e) {
      savePrint('Error formatting dateTime to month: ' + e.toString());
      return '';
    }
  }
}

extension DateTimeExtension on DateTime {
  DateTime getThisDateWithSysdateTime() {
    DateTime sysdate = DateTime.now();
    return DateTime(sysdate.year, sysdate.month, sysdate.day, this.hour, this.minute, this.second, this.millisecond,
        this.microsecond);
  }

  DateTime roundToHour() {
    return DateTime(this.year, this.month, this.day, this.hour, 0, 0, 0, 0);
  }

  DateTime changeTo({required DateTime selectedDate, required bool leaveTimeAsIs}) {
    if (leaveTimeAsIs) {
      return DateTime(selectedDate.year, selectedDate.month, selectedDate.day, this.hour, this.minute, this.second,
          this.millisecond, this.microsecond);
    } else {
      return DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedDate.hour, selectedDate.minute,
          selectedDate.second, selectedDate.millisecond, selectedDate.microsecond);
    }
  }

  DateTime getThisDateWithHour(int hour) {
    return DateTime(this.year, this.month, this.day, hour, 0, 0, 0, 0);
  }
}
