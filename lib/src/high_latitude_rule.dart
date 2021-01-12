/// Rules for dealing with Fajr and Isha at places with high latitudes
enum HighLatitudeRule {
  /// Fajr will never be earlier than the middle of the night, and Isha will never be later than
  /// the middle of the night.
  middle_of_the_night,

  /// Fajr will never be earlier than the beginning of the last seventh of the night, and Isha will
  /// never be later than the end of hte first seventh of the night.
  seventh_of_the_night,

  /// Similar to [HighLatitudeRule.seventh_of_the_night], but instead of 1/7th, the faction
  /// of the night used is fajrAngle / 60 and ishaAngle/60.
  twilight_angle
}
