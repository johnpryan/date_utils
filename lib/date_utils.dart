library utils;

import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';

class Utils {
  static String formatMonth(DateTime d, {String locale}) {
    initializeDateFormatting(locale, null);
    return DateFormat("MMMM yyyy", locale).format(d);
  }

  static String formatDay(DateTime d, {String locale}) {
    initializeDateFormatting(locale, null);
    return DateFormat("dd", locale).format(d);
  }

  static String formatFirstDay(DateTime d, {String locale}) {
    initializeDateFormatting(locale, null);
    return DateFormat("MMM dd", locale).format(d);
  }

  static String fullDayFormat(DateTime d, {String locale}) {
    initializeDateFormatting(locale, null);
    return DateFormat("EEE MMM dd, yyyy", locale).format(d);
  }

  static String apiDayFormat(DateTime d, {String locale}) {
    initializeDateFormatting(locale, null);
    return DateFormat("yyyy-MM-dd", locale).format(d);
  }

  static String customFormat(DateTime d, {String locale, DateFormat formatter}) {
    initializeDateFormatting(locale, null);
    return formatter.format(d);
  }

  static List<String> weekdays = weekdaysLocale();

  static List<String> weekdaysLocale({locale = 'en'}) {
    initializeDateFormatting(locale, null);
    return [
      new DateFormat('EEE', locale).format(new DateTime.utc(2020, 02, 09)).toUpperCase(),
      new DateFormat('EEE', locale).format(new DateTime.utc(2020, 02, 10)).toUpperCase(),
      new DateFormat('EEE', locale).format(new DateTime.utc(2020, 02, 11)).toUpperCase(),
      new DateFormat('EEE', locale).format(new DateTime.utc(2020, 02, 12)).toUpperCase(),
      new DateFormat('EEE', locale).format(new DateTime.utc(2020, 02, 13)).toUpperCase(),
      new DateFormat('EEE', locale).format(new DateTime.utc(2020, 02, 14)).toUpperCase(),
      new DateFormat('EEE', locale).format(new DateTime.utc(2020, 02, 15)).toUpperCase(),
    ];
  }

  /// The list of days in a given month
  static List<DateTime> daysInMonth(DateTime month) {
    var first = firstDayOfMonth(month);
    var daysBefore = first.weekday;
    var firstToDisplay = first.subtract(new Duration(days: daysBefore));
    var last = Utils.lastDayOfMonth(month);

    var daysAfter = 7 - last.weekday;

    // If the last day is sunday (7) the entire week must be rendered
    if (daysAfter == 0) {
      daysAfter = 7;
    }

    var lastToDisplay = last.add(new Duration(days: daysAfter));
    return daysInRange(firstToDisplay, lastToDisplay).toList();
  }

  static bool isFirstDayOfMonth(DateTime day) {
    return isSameDay(firstDayOfMonth(day), day);
  }

  static bool isLastDayOfMonth(DateTime day) {
    return isSameDay(lastDayOfMonth(day), day);
  }

  static DateTime firstDayOfMonth(DateTime month) {
    return new DateTime(month.year, month.month);
  }

  static DateTime firstDayOfWeek(DateTime day) {
    /// Handle Daylight Savings by setting hour to 12:00 Noon
    /// rather than the default of Midnight
    day = new DateTime.utc(day.year, day.month, day.day, 12);

    /// Weekday is on a 1-7 scale Monday - Sunday,
    /// This Calendar works from Sunday - Monday
    var decreaseNum = day.weekday % 7;
    return day.subtract(new Duration(days: decreaseNum));
  }

  static DateTime lastDayOfWeek(DateTime day) {
    /// Handle Daylight Savings by setting hour to 12:00 Noon
    /// rather than the default of Midnight
    day = new DateTime.utc(day.year, day.month, day.day, 12);

    /// Weekday is on a 1-7 scale Monday - Sunday,
    /// This Calendar's Week starts on Sunday
    var increaseNum = day.weekday % 7;
    return day.add(new Duration(days: 7 - increaseNum));
  }

  /// The last day of a given month
  static DateTime lastDayOfMonth(DateTime month) {
    var beginningNextMonth =
        (month.month < 12) ? new DateTime(month.year, month.month + 1, 1) : new DateTime(month.year + 1, 1, 1);
    return beginningNextMonth.subtract(new Duration(days: 1));
  }

  /// Returns a [DateTime] for each day the given range.
  ///
  /// [start] inclusive
  /// [end] exclusive
  static Iterable<DateTime> daysInRange(DateTime start, DateTime end) sync* {
    var i = start;
    var offset = start.timeZoneOffset;
    while (i.isBefore(end)) {
      yield i;
      i = i.add(new Duration(days: 1));
      var timeZoneDiff = i.timeZoneOffset - offset;
      if (timeZoneDiff.inSeconds != 0) {
        offset = i.timeZoneOffset;
        i = i.subtract(new Duration(seconds: timeZoneDiff.inSeconds));
      }
    }
  }

  /// Whether or not two times are on the same day.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool isSameWeek(DateTime a, DateTime b) {
    /// Handle Daylight Savings by setting hour to 12:00 Noon
    /// rather than the default of Midnight
    a = new DateTime.utc(a.year, a.month, a.day);
    b = new DateTime.utc(b.year, b.month, b.day);

    var diff = a.toUtc().difference(b.toUtc()).inDays;
    if (diff.abs() >= 7) {
      return false;
    }

    var min = a.isBefore(b) ? a : b;
    var max = a.isBefore(b) ? b : a;
    var result = max.weekday % 7 - min.weekday % 7 >= 0;
    return result;
  }

  static DateTime previousMonth(DateTime m) {
    var year = m.year;
    var month = m.month;
    if (month == 1) {
      year--;
      month = 12;
    } else {
      month--;
    }
    return new DateTime(year, month);
  }

  static DateTime nextMonth(DateTime m) {
    var year = m.year;
    var month = m.month;

    if (month == 12) {
      year++;
      month = 1;
    } else {
      month++;
    }
    return new DateTime(year, month);
  }

  static DateTime previousWeek(DateTime w) {
    return w.subtract(new Duration(days: 7));
  }

  static DateTime nextWeek(DateTime w) {
    return w.add(new Duration(days: 7));
  }
}
