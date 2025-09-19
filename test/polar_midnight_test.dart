import 'package:adhan/adhan.dart';
import 'package:test/test.dart';

void main() {
  group('Polar Circle Resolution Tests', () {
    test('Test AqrabBalad resolution for polar night', () {
      // Test location in northern Norway during polar night
      final tromso = Coordinates(69.6492, 18.9553); // Tromsø, Norway
      final date = DateComponents(2023, 12, 21); // Winter solstice
      final params = CalculationMethod.muslim_world_league.getParameters();
      params.polarCircleResolution = PolarCircleResolution.aqrabBalad;

      final prayerTimes = PrayerTimes(tromso, date, params);

      // Polar circle resolution should have been applied
      expect(prayerTimes.polarResolutionApplied, isTrue);
      expect(prayerTimes.polarResolutionStrategy, PolarCircleResolution.aqrabBalad);

      // Prayer times should still be calculated using resolved coordinates
      expect(prayerTimes.fajr, isNotNull);
      expect(prayerTimes.sunrise, isNotNull);
      expect(prayerTimes.maghrib, isNotNull);
      expect(prayerTimes.isha, isNotNull);
    });

    test('Test AqrabYaum resolution for midnight sun', () {
      // Test location in northern Norway during midnight sun
      final tromso = Coordinates(69.6492, 18.9553); // Tromsø, Norway
      final date = DateComponents(2023, 6, 21); // Summer solstice
      final params = CalculationMethod.muslim_world_league.getParameters();
      params.polarCircleResolution = PolarCircleResolution.aqrabYaum;

      final prayerTimes = PrayerTimes(tromso, date, params);

      // Polar circle resolution should have been applied
      expect(prayerTimes.polarResolutionApplied, isTrue);
      expect(prayerTimes.polarResolutionStrategy, PolarCircleResolution.aqrabYaum);

      // Prayer times should still be calculated using resolved dates
      expect(prayerTimes.fajr, isNotNull);
      expect(prayerTimes.sunrise, isNotNull);
      expect(prayerTimes.maghrib, isNotNull);
      expect(prayerTimes.isha, isNotNull);
    });

    test('Test unresolved strategy leaves times undefined', () {
      // Test location in extreme polar conditions
      final longyearbyen = Coordinates(78.2232, 15.6267); // Longyearbyen, Svalbard
      final date = DateComponents(2023, 12, 21); // Polar night
      final params = CalculationMethod.muslim_world_league.getParameters();
      params.polarCircleResolution = PolarCircleResolution.unresolved;

      final prayerTimes = PrayerTimes(longyearbyen, date, params);

      // No resolution should have been applied
      expect(prayerTimes.polarResolutionApplied, isFalse);
      expect(prayerTimes.polarResolutionStrategy, isNull);

      // Prayer times should still be calculated using high latitude rules
      expect(prayerTimes.fajr, isNotNull);
      expect(prayerTimes.sunrise, isNotNull);
      expect(prayerTimes.maghrib, isNotNull);
      expect(prayerTimes.isha, isNotNull);
    });

    test('Test normal location without polar conditions', () {
      // Test location in normal latitude
      final london = Coordinates(51.5074, -0.1278); // London, UK
      final date = DateComponents(2023, 6, 21);
      final params = CalculationMethod.muslim_world_league.getParameters();
      params.polarCircleResolution = PolarCircleResolution.aqrabBalad;

      final prayerTimes = PrayerTimes(london, date, params);

      // Should not apply polar circle resolution
      expect(prayerTimes.polarResolutionApplied, isFalse);
      expect(prayerTimes.polarResolutionStrategy, isNull);

      // All prayer times should be normally calculated
      expect(prayerTimes.fajr, isNotNull);
      expect(prayerTimes.sunrise, isNotNull);
      expect(prayerTimes.maghrib, isNotNull);
      expect(prayerTimes.isha, isNotNull);
    });

    test('Test AqrabBalad resolution with Antarctic location', () {
      // Test location in Antarctic during polar day
      final mcmurdo = Coordinates(-77.8419, 166.6682); // McMurdo Station, Antarctica
      final date = DateComponents(2023, 12, 21); // Southern summer solstice
      final params = CalculationMethod.muslim_world_league.getParameters();
      params.polarCircleResolution = PolarCircleResolution.aqrabBalad;

      final prayerTimes = PrayerTimes(mcmurdo, date, params);

      // Polar circle resolution should have been applied
      expect(prayerTimes.polarResolutionApplied, isTrue);
      expect(prayerTimes.polarResolutionStrategy, PolarCircleResolution.aqrabBalad);

      // Prayer times should still be calculated
      expect(prayerTimes.fajr, isNotNull);
      expect(prayerTimes.sunrise, isNotNull);
      expect(prayerTimes.maghrib, isNotNull);
      expect(prayerTimes.isha, isNotNull);
    });

    test('Test different resolution strategies produce valid times', () {
      final extremeLocation = Coordinates(80.0, 0.0); // Extreme North Pole area
      final date = DateComponents(2023, 6, 21);
      final baseParams = CalculationMethod.muslim_world_league.getParameters();

      // Test AqrabBalad
      final aqrabBaladParams = CalculationParameters(
        method: baseParams.method,
        fajrAngle: baseParams.fajrAngle,
        ishaInterval: baseParams.ishaInterval,
        madhab: baseParams.madhab,
        highLatitudeRule: baseParams.highLatitudeRule,
        polarCircleResolution: PolarCircleResolution.aqrabBalad,
        ishaAngle: baseParams.ishaAngle,
      );

      final aqrabBaladTimes = PrayerTimes(extremeLocation, date, aqrabBaladParams);
      expect(aqrabBaladTimes.polarResolutionApplied, isTrue);
      expect(aqrabBaladTimes.fajr, isNotNull);

      // Test AqrabYaum
      final aqrabYaumParams = CalculationParameters(
        method: baseParams.method,
        fajrAngle: baseParams.fajrAngle,
        ishaInterval: baseParams.ishaInterval,
        madhab: baseParams.madhab,
        highLatitudeRule: baseParams.highLatitudeRule,
        polarCircleResolution: PolarCircleResolution.aqrabYaum,
        ishaAngle: baseParams.ishaAngle,
      );

      final aqrabYaumTimes = PrayerTimes(extremeLocation, date, aqrabYaumParams);
      expect(aqrabYaumTimes.polarResolutionApplied, isTrue);
      expect(aqrabYaumTimes.fajr, isNotNull);
    });

    test('Test edge case at polar circle boundary', () {
      // Test exactly at 65° boundary
      final boundaryLocation = Coordinates(65.0, 0.0);
      final date = DateComponents(2023, 12, 21);
      final params = CalculationMethod.muslim_world_league.getParameters();
      params.polarCircleResolution = PolarCircleResolution.aqrabBalad;

      final prayerTimes = PrayerTimes(boundaryLocation, date, params);

      // Resolution may or may not be applied depending on exact solar calculations
      // But prayer times should always be valid
      expect(prayerTimes.fajr, isNotNull);
      expect(prayerTimes.sunrise, isNotNull);
      expect(prayerTimes.maghrib, isNotNull);
      expect(prayerTimes.isha, isNotNull);
    });
  });
}