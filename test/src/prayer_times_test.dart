import 'dart:convert';
import 'dart:io';

import 'package:adhan/adhan.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:strings/strings.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:test/test.dart';

void main() {
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

  test('Test Prayer Times in Wide Range Locations From JSON Data.', () async {
    await tz.initializeTimeZone();

    final jsonDir = Directory('./test/data/prayer-times');
    final files = jsonDir.listSync();
    files.forEach((fileEntity) {
      final file = fileEntity;
      if (file.path.endsWith('.json') && file is File) {
        print('Testing Timings For: ${basename(file.path)}');

        final jsonString = file.readAsStringSync();
        final data = json.decode(jsonString);
        final params = data['params'];
        final variance = data['variance'];
        final times = data['times'] as List<dynamic>;

        // Convert String Params to Enums
        final madhab = EnumToString.fromString(Madhab.values, params['madhab']);
        final highLatitudeRule = EnumToString.fromString(
            HighLatitudeRule.values, underscore(params['highLatitudeRule']));

        if (params['method'] == 'MoonsightingCommittee') {
          params['method'] = 'MoonSightingCommittee';
        }
        final calculationMethod = EnumToString.fromString(
            CalculationMethod.values, underscore(params['method']));
        final calculationParams = calculationMethod.getParameters();
        calculationParams.madhab = madhab;
        calculationParams.highLatitudeRule = highLatitudeRule;

        // Get Coordinates
        final coordinates =
            Coordinates(params['latitude'], params['longitude']);
        final locationTz = tz.getLocation(params['timezone']);

        times.forEach((time) {
          final date = DateTime.tryParse(time['date']);
          if (date != null) {
            final prayerTimes = PrayerTimes(
                coordinates, DateComponents.from(date), calculationParams);

            if (variance == null) {
              expect(
                  DateFormat.jm()
                      .format(tz.TZDateTime.from(prayerTimes.fajr, locationTz)),
                  time['fajr']);
              expect(
                  DateFormat.jm().format(
                      tz.TZDateTime.from(prayerTimes.sunrise, locationTz)),
                  time['sunrise']);
              expect(
                  DateFormat.jm().format(
                      tz.TZDateTime.from(prayerTimes.dhuhr, locationTz)),
                  time['dhuhr']);
              expect(
                  DateFormat.jm()
                      .format(tz.TZDateTime.from(prayerTimes.asr, locationTz)),
                  time['asr']);
              expect(
                  DateFormat.jm().format(
                      tz.TZDateTime.from(prayerTimes.maghrib, locationTz)),
                  time['maghrib']);
              expect(
                  DateFormat.jm()
                      .format(tz.TZDateTime.from(prayerTimes.isha, locationTz)),
                  time['isha']);
            }
          }
        });
      }
    });
  });
}
