/// Adjustment value for prayer times, in minutes
/// These values are added (or subtracted) from the prayer time that is calculated before
/// returning the result times.
class PrayerAdjustments {
  /// Fajr offset in minutes
  int fajr;

  /// Sunrise offset in minutes
  int sunrise;

  /// Dhuhr offset in minutes
  int dhuhr;

  /// Asr offset in minutes
  int asr;

  /// Maghrib offset in minutes
  int maghrib;

  /// Isha offset in minutes
  int isha;

  /// Gets a PrayerAdjustments object to offset prayer times
  /// [fajr] offset from fajr in minutes
  /// [sunrise] offset from sunrise in minutes
  /// [dhuhr] offset from dhuhr in minutes
  /// [asr] offset from asr in minutes
  /// [maghrib] offset from maghrib in minutes
  /// [isha] offset from isha in minutes
  PrayerAdjustments(
      {this.fajr = 0,
      this.sunrise = 0,
      this.dhuhr = 0,
      this.asr = 0,
      this.maghrib = 0,
      this.isha = 0});
}
