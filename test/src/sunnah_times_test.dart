import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'package:test/test.dart';

void main() {
  test('Test SunnahTimes NewYork', () {
    final params = CalculationMethod.north_america.getParameters();
    final coordinates = Coordinates(35.7750, -78.6336);
    final newYorkUtcOffset = Duration(hours: -4);

    final todayComponents = DateComponents(2015, 7, 12);
    final todayPrayers = PrayerTimes(coordinates, todayComponents, params,
        utcOffset: newYorkUtcOffset);

    expect(DateFormat.yMd().add_jm().format(todayPrayers.maghrib),
        '7/12/2015 8:32 PM');

    final tomorrowComponents = DateComponents(2015, 7, 13);
    final tomorrowPrayers = PrayerTimes(coordinates, tomorrowComponents, params,
        utcOffset: newYorkUtcOffset);

    expect(DateFormat.yMd().add_jm().format(tomorrowPrayers.fajr),
        '7/13/2015 4:43 AM');

    /*
     Night: 8:32 PM to 4:43 AM
     Duration: 8 hours, 11 minutes
     Middle = 8:32 PM + 4 hours, 5.5 minutes = 12:37:30 AM which rounds to 12:38 AM
     Last Third = 8:32 PM + 5 hours, 27.3 minutes = 1:59:20 AM which rounds to 1:59 AM
     */
    final sunnahTimes = SunnahTimes(todayPrayers);
    expect(DateFormat.yMd().add_jm().format(sunnahTimes.middleOfTheNight),
        '7/13/2015 12:38 AM');
    expect(DateFormat.yMd().add_jm().format(sunnahTimes.lastThirdOfTheNight),
        '7/13/2015 1:59 AM');
  });
}
