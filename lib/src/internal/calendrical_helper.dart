class CalendricalHelper {
  /// The Julian Day for a given Gregorian date
  /// @param year the year
  /// @param month the month
  /// @param day the day
  /// @param hours hours
  /// @return the julian day
  static double julianDay(int year, int month, int day, {double hours = 0.0}) {
    /* Equation from Astronomical Algorithms page 60 */

    // NOTE: Integer conversion is done intentionally for the purpose of decimal truncation

    final Y = month > 2 ? year : year - 1;
    final M = month > 2 ? month : month + 12;
    final D = day + (hours / 24);

    final A = Y ~/ 100;
    final B = (2 - A + (A / 4)).toInt();

    final i0 = (365.25 * (Y + 4716)).toInt();
    final i1 = (30.6001 * (M + 1)).toInt();
    return i0 + i1 + D + B - 1524.5;
  }

  /// The Julian Day for a given date
  /// @param date the date
  /// @return the julian day
  static double julianDayByDate(DateTime _date) {
    final date = _date;
    return julianDay(date.year, date.month, date.day,
        hours: (date.hour + date.minute) / 60.0);
  }

  /// Julian century from the epoch.
  /// @param JD the julian day
  /// @return the julian century from the epoch
  static double julianCentury(double JD) {
    /* Equation from Astronomical Algorithms page 163 */
    return (JD - 2451545.0) / 36525;
  }
}
