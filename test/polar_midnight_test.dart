import 'package:adhan/adhan.dart';
import 'package:test/test.dart';

void main() {
  group('Polar Night and Midnight Sun Tests', () {
    test('Test polar night detection in high latitude location', () {
      // Test location in northern Norway during polar night
      final tromso = Coordinates(69.6492, 18.9553); // Tromsø, Norway
      final date = DateComponents(2023, 12, 21); // Winter solstice
      final params = CalculationMethod.muslim_world_league.getParameters();
      
      final prayerTimes = PrayerTimes(tromso, date, params);
      
      // During polar night, we should detect the condition
      expect(prayerTimes.isPolarNight, isTrue);
      
      // Prayer times should still be calculated using fallback methods
      expect(prayerTimes.fajr, isNotNull);
      expect(prayerTimes.sunrise, isNotNull);
      expect(prayerTimes.maghrib, isNotNull);
      expect(prayerTimes.isha, isNotNull);
    });

    test('Test midnight sun detection in high latitude location', () {
      // Test location in northern Norway during midnight sun
      final tromso = Coordinates(69.6492, 18.9553); // Tromsø, Norway
      final date = DateComponents(2023, 6, 21); // Summer solstice
      final params = CalculationMethod.muslim_world_league.getParameters();
      
      final prayerTimes = PrayerTimes(tromso, date, params);
      
      // During midnight sun, we should detect the condition
      expect(prayerTimes.isMidnightSun, isTrue);
      
      // Prayer times should still be calculated using fallback methods
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
      
      final prayerTimes = PrayerTimes(london, date, params);
      
      // Should not detect polar conditions
      expect(prayerTimes.isPolarNight, isFalse);
      expect(prayerTimes.isMidnightSun, isFalse);
    });

    // Static methods are internal and tested indirectly through the public interface
  });
}