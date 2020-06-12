import 'package:adhan/src/extensions/datetime.dart';

import 'date_components.dart';

class CalendarUtil {
  /// Whether or not a year is a leap year (has 366 days)
  /// @param year the year
  /// @return whether or not its a leap year
  static bool isLeapYear(int year) {
    return year % 4 == 0 && !(year % 100 == 0 && year % 400 != 0);
  }

  /// Date and time with a rounded minute
  /// This returns a date with the seconds rounded and added to the minute
  /// @param when the date and time
  /// @return the date and time with 0 seconds and minutes including rounded seconds
  static DateTime roundedMinute(DateTime _when) {
    final when = _when;
    final minute = when.minute;
    final second = when.second;
    return when.copyWith(minute: (minute + (second / 60).round()), second: 0);
  }

  /// Gets a date for the particular date
  /// @param components the date components
  /// @return the date with a time set to 00:00:00 at utc
  static DateTime resolveTimeByDateComponents(DateComponents components) {
    return resolveTime(components.year, components.month, components.day);
  }

  /// Gets a date for the particular date
  /// @param year the year
  /// @param month the month
  /// @param day the day
  /// @return the date with a time set to 00:00:00 at utc
  static DateTime resolveTime(int year, int month, int day) {
    return DateTime(year, month, day, 0, 0, 0);
  }
}