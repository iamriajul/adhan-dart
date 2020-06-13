import 'package:adhan/adhan.dart';
import 'package:adhan/src/extensions/datetime.dart';
import 'package:intl/intl.dart';
import 'package:test/test.dart';

void main() {
  group('Test Prayer Times', () {
    test('Test Prayer Time in Kushtia', () {
      final kushtia = Coordinates(23.9088, 89.1220);
      final kushtiaUtcOffset = Duration(hours: 6);
      final date = DateComponents(2020, 6, 12);
      final params = CalculationMethod.karachi.getParameters();
      params.madhab = Madhab.hanafi;

      final prayerTimes =
          PrayerTimes(kushtia, date, params, utcOffset: kushtiaUtcOffset);

      expect(DateFormat.jm().format(prayerTimes.fajr), '3:48 AM');
      expect(DateFormat.jm().format(prayerTimes.sunrise), '5:16 AM');
      expect(DateFormat.jm().format(prayerTimes.dhuhr), '12:04 PM');
      expect(DateFormat.jm().format(prayerTimes.asr), '4:44 PM');
      expect(DateFormat.jm().format(prayerTimes.maghrib), '6:51 PM');
      expect(DateFormat.jm().format(prayerTimes.isha), '8:19 PM');
    });

    test('Test Prayer Time in NewYork', () {
      // with custom timezone UTC Offset.

      final newYork = Coordinates(35.7750, -78.6336);
      final nyUtcOffset = Duration(hours: -4);
      final nyDate = DateComponents(2015, 7, 12);
      final nyParams = CalculationMethod.north_america.getParameters();
      nyParams.madhab = Madhab.hanafi;
      final nyPrayerTimes =
          PrayerTimes(newYork, nyDate, nyParams, utcOffset: nyUtcOffset);

      expect(DateFormat.jm().format(nyPrayerTimes.fajr), '4:42 AM');
      expect(DateFormat.jm().format(nyPrayerTimes.sunrise), '6:08 AM');
      expect(DateFormat.jm().format(nyPrayerTimes.dhuhr), '1:21 PM');
      expect(DateFormat.jm().format(nyPrayerTimes.asr), '6:22 PM');
      expect(DateFormat.jm().format(nyPrayerTimes.maghrib), '8:32 PM');
      expect(DateFormat.jm().format(nyPrayerTimes.isha), '9:57 PM');
    });
  });

  group('Test Extensions', () {
    test('Test dayOfYear with DateTime', () {
      final myDate = DateTime(2020, 3, 2, 14, 30);
      // in 2020
      // January has 31 days
      // February has 29 Days
      // March has 31 Days
      // so 31 + 29 and + 2 = 62
      expect(myDate.dayOfYear, 62);
    });
  });
}
