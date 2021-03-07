import 'calculation_parameters.dart';
import 'prayer_adjustments.dart';

/// Standard calculation methods for calculating prayer times
enum CalculationMethod {
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

  /// Moon Sighting Committee
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

  /// Dianet
  turkey,

  /// Institute of Geophysics, University of Tehran. Early Isha time with an angle of 14°. Slightly later Fajr time with an angle of 17.7°.
  /// Calculates Maghrib based on the sun reaching an angle of 4.5° below the horizon.
  tehran,

  /// The default value for [CalculationParameters.method] when initializing a
  /// [CalculationParameters] object. Sets a Fajr angle of 0 and an Isha angle of 0.
  other
}

extension CalculationMethodExtensions on CalculationMethod {
  /// Return the CalculationParameters for the given method
  /// return CalculationParameters for the given Calculation method
  CalculationParameters getParameters() {
    switch (this) {
      case CalculationMethod.muslim_world_league:
        {
          return CalculationParameters(
                  fajrAngle: 18.0, ishaAngle: 17.0, method: this)
              .withMethodAdjustments(PrayerAdjustments(
                  fajr: 0, sunrise: 0, dhuhr: 1, asr: 0, maghrib: 0, isha: 0));
        }
      case CalculationMethod.egyptian:
        {
          return CalculationParameters(
                  fajrAngle: 19.5, ishaAngle: 17.5, method: this)
              .withMethodAdjustments(PrayerAdjustments(
                  fajr: 0, sunrise: 0, dhuhr: 1, asr: 0, maghrib: 0, isha: 0));
        }
      case CalculationMethod.karachi:
        {
          return CalculationParameters(
                  fajrAngle: 18.0, ishaAngle: 18.0, method: this)
              .withMethodAdjustments(PrayerAdjustments(
                  fajr: 0, sunrise: 0, dhuhr: 1, asr: 0, maghrib: 0, isha: 0));
        }
      case CalculationMethod.umm_al_qura:
        {
          return CalculationParameters(
              fajrAngle: 18.5, ishaInterval: 90, method: this);
        }
      case CalculationMethod.dubai:
        {
          return CalculationParameters(
                  fajrAngle: 18.2, ishaAngle: 18.2, method: this)
              .withMethodAdjustments(PrayerAdjustments(
                  fajr: 0, sunrise: -3, dhuhr: 3, asr: 3, maghrib: 3, isha: 0));
        }
      case CalculationMethod.moon_sighting_committee:
        {
          return CalculationParameters(
                  fajrAngle: 18.0, ishaAngle: 18.0, method: this)
              .withMethodAdjustments(PrayerAdjustments(
                  fajr: 0, sunrise: 0, dhuhr: 5, asr: 0, maghrib: 3, isha: 0));
        }
      case CalculationMethod.north_america:
        {
          return CalculationParameters(
                  fajrAngle: 15.0, ishaAngle: 15.0, method: this)
              .withMethodAdjustments(PrayerAdjustments(
                  fajr: 0, sunrise: 0, dhuhr: 1, asr: 0, maghrib: 0, isha: 0));
        }
      case CalculationMethod.kuwait:
        {
          return CalculationParameters(
              fajrAngle: 18.0, ishaAngle: 17.5, method: this);
        }
      case CalculationMethod.qatar:
        {
          return CalculationParameters(
              fajrAngle: 18.0, ishaInterval: 90, method: this);
        }
      case CalculationMethod.singapore:
        {
          return CalculationParameters(
                  fajrAngle: 20.0, ishaAngle: 18.0, method: this)
              .withMethodAdjustments(PrayerAdjustments(
                  fajr: 0, sunrise: 0, dhuhr: 1, asr: 0, maghrib: 0, isha: 0));
        }
      case CalculationMethod.turkey:
        {
          return CalculationParameters(
                  fajrAngle: 18.0, ishaAngle: 17.0, method: this)
              .withMethodAdjustments(PrayerAdjustments(
                  fajr: 0, sunrise: -7, dhuhr: 5, asr: 4, maghrib: 7, isha: 0));
        }
      case CalculationMethod.tehran:
        {
          return CalculationParameters(
            fajrAngle: 17.7,
            ishaAngle: 14,
            maghribAngle: 4.5,
            method: this,
          );
        }
      case CalculationMethod.other:
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
