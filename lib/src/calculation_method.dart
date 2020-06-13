import 'calculation_parameters.dart';
import 'prayer_adjustments.dart';

enum _CalculationMethod {
  /// Muslim World League
  /// Uses Fajr angle of 18 and an Isha angle of 17
  muslim_world_league,

  /// Egyptian General Authority of Survey
  /// Uses Fajr angle of 19.5 and an Isha angle of 17.5
  egyptian,

  /// University of Islamic Sciences, Karachi
  /// Uses Fajr angle of 18 and an Isha angle of 18
  karachi,

  /// Umm al-Qura University, Makkah
  /// Uses a Fajr angle of 18.5 and an Isha angle of 90. Note: You should add a +30 minute custom
  /// adjustment of Isha during Ramadan.
  umm_al_qura,

  /// The Gulf Region
  /// Uses Fajr and Isha angles of 18.2 degrees.
  dubai,

  /// Moonsighting Committee
  /// Uses a Fajr angle of 18 and an Isha angle of 18. Also uses seasonal adjustment values.
  moon_sighting_committee,

  /// Referred to as the ISNA method
  /// This method is included for completeness, but is not recommended.
  /// Uses a Fajr angle of 15 and an Isha angle of 15.
  north_america,

  /// Kuwait
  /// Uses a Fajr angle of 18 and an Isha angle of 17.5
  kuwait,

  /// Qatar
  /// Modified version of Umm al-Qura that uses a Fajr angle of 18.
  qatar,

  /// Singapore
  /// Uses a Fajr angle of 20 and an Isha angle of 18
  singapore,

  /// The default value for [CalculationParameters.method] when initializing a
  /// [CalculationParameters] object. Sets a Fajr angle of 0 and an Isha angle of 0.
  other
}

class CalculationMethod {
  final _CalculationMethod _value;

  @override
  String toString() {
    return _value.toString();
  }

  CalculationMethod._(this._value);

  /// Muslim World League
  /// Uses Fajr angle of 18 and an Isha angle of 17
  static CalculationMethod get muslim_world_league =>
      CalculationMethod._(_CalculationMethod.muslim_world_league);

  /// Egyptian General Authority of Survey
  /// Uses Fajr angle of 19.5 and an Isha angle of 17.5
  static CalculationMethod get egyptian =>
      CalculationMethod._(_CalculationMethod.egyptian);

  /// University of Islamic Sciences, Karachi
  /// Uses Fajr angle of 18 and an Isha angle of 18
  static CalculationMethod get karachi =>
      CalculationMethod._(_CalculationMethod.karachi);

  /// Umm al-Qura University, Makkah
  /// Uses a Fajr angle of 18.5 and an Isha angle of 90. Note: You should add a +30 minute custom
  /// adjustment of Isha during Ramadan.
  static CalculationMethod get umm_al_qura =>
      CalculationMethod._(_CalculationMethod.umm_al_qura);

  /// The Gulf Region
  /// Uses Fajr and Isha angles of 18.2 degrees.
  static CalculationMethod get dubai =>
      CalculationMethod._(_CalculationMethod.dubai);

  /// Moonsighting Committee
  /// Uses a Fajr angle of 18 and an Isha angle of 18. Also uses seasonal adjustment values.
  static CalculationMethod get moon_sighting_committee =>
      CalculationMethod._(_CalculationMethod.moon_sighting_committee);

  /// Referred to as the ISNA method
  /// This method is included for completeness, but is not recommended.
  /// Uses a Fajr angle of 15 and an Isha angle of 15.
  static CalculationMethod get north_america =>
      CalculationMethod._(_CalculationMethod.north_america);

  /// Kuwait
  /// Uses a Fajr angle of 18 and an Isha angle of 17.5
  static CalculationMethod get kuwait =>
      CalculationMethod._(_CalculationMethod.kuwait);

  /// Qatar
  /// Modified version of Umm al-Qura that uses a Fajr angle of 18.
  static CalculationMethod get qatar =>
      CalculationMethod._(_CalculationMethod.qatar);

  /// Singapore
  /// Uses a Fajr angle of 20 and an Isha angle of 18
  static CalculationMethod get singapore =>
      CalculationMethod._(_CalculationMethod.singapore);

  /// The default value for [CalculationParameters.method] when initializing a
  /// [CalculationParameters] object. Sets a Fajr angle of 0 and an Isha angle of 0.
  static CalculationMethod get other =>
      CalculationMethod._(_CalculationMethod.other);

  /// Return the CalculationParameters for the given method
  /// return CalculationParameters for the given Calculation method
  CalculationParameters getParameters() {
    switch (_value) {
      case _CalculationMethod.muslim_world_league:
        {
          return CalculationParameters(
                  fajrAngle: 18.0, ishaAngle: 17.0, method: this)
              .withMethodAdjustments(PrayerAdjustments(
                  fajr: 0, sunrise: 0, dhuhr: 1, asr: 0, maghrib: 0, isha: 0));
        }
      case _CalculationMethod.egyptian:
        {
          return CalculationParameters(
                  fajrAngle: 20.0, ishaAngle: 18.0, method: this)
              .withMethodAdjustments(PrayerAdjustments(
                  fajr: 0, sunrise: 0, dhuhr: 1, asr: 0, maghrib: 0, isha: 0));
        }
      case _CalculationMethod.karachi:
        {
          return CalculationParameters(
                  fajrAngle: 18.0, ishaAngle: 18.0, method: this)
              .withMethodAdjustments(PrayerAdjustments(
                  fajr: 0, sunrise: 0, dhuhr: 1, asr: 0, maghrib: 0, isha: 0));
        }
      case _CalculationMethod.umm_al_qura:
        {
          return CalculationParameters(
              fajrAngle: 18.5, ishaAngle: 90, method: this);
        }
      case _CalculationMethod.dubai:
        {
          return CalculationParameters(
                  fajrAngle: 18.2, ishaAngle: 18.2, method: this)
              .withMethodAdjustments(PrayerAdjustments(
                  fajr: 0, sunrise: -3, dhuhr: 3, asr: 3, maghrib: 3, isha: 0));
        }
      case _CalculationMethod.moon_sighting_committee:
        {
          return CalculationParameters(
                  fajrAngle: 18.0, ishaAngle: 18.0, method: this)
              .withMethodAdjustments(PrayerAdjustments(
                  fajr: 0, sunrise: 0, dhuhr: 5, asr: 0, maghrib: 3, isha: 0));
        }
      case _CalculationMethod.north_america:
        {
          return CalculationParameters(
                  fajrAngle: 15.0, ishaAngle: 15.0, method: this)
              .withMethodAdjustments(PrayerAdjustments(
                  fajr: 0, sunrise: 0, dhuhr: 1, asr: 0, maghrib: 0, isha: 0));
        }
      case _CalculationMethod.kuwait:
        {
          return CalculationParameters(
              fajrAngle: 18.0, ishaAngle: 17.5, method: this);
        }
      case _CalculationMethod.qatar:
        {
          return CalculationParameters(
              fajrAngle: 18.0, ishaAngle: 90, method: this);
        }
      case _CalculationMethod.singapore:
        {
          return CalculationParameters(
                  fajrAngle: 20.0, ishaAngle: 18.0, method: this)
              .withMethodAdjustments(PrayerAdjustments(
                  fajr: 0, sunrise: 0, dhuhr: 1, asr: 0, maghrib: 0, isha: 0));
        }
      case _CalculationMethod.other:
        {
          return CalculationParameters(
              fajrAngle: 0.0, ishaAngle: 0.0, method: this);
        }
      default:
        {
          throw FormatException('Invalid CalculationMethod');
        }
    }
  }
}
