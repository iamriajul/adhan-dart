import 'dart:convert';
import 'dart:io';

import 'package:adhan/adhan.dart';
import 'package:adhan/src/data/calendar_util.dart';
import 'package:adhan/src/extensions/datetime.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:strings/strings.dart';
import 'package:timezone/standalone.dart';
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

  test(
      'Test PrayerTimes for Local Timezone Output When Not Setting utcOffset param',
      () {
    final kushtia = Coordinates(23.9088, 89.1220);
    final date = DateComponents(2020, 6, 12);
    final params = CalculationMethod.karachi.getParameters();
    params.madhab = Madhab.hanafi;

    final prayerTimes = PrayerTimes(kushtia, date, params);

    expect(prayerTimes.fajr.isUtc, false);
    expect(prayerTimes.sunrise.isUtc, false);
    expect(prayerTimes.dhuhr.isUtc, false);
    expect(prayerTimes.asr.isUtc, false);
    expect(prayerTimes.maghrib.isUtc, false);
    expect(prayerTimes.isha.isUtc, false);
  });

  test('Test PrayerTimes.timeForPrayer', () {
    final kushtia = Coordinates(23.9088, 89.1220);
    final kushtiaUtcOffset = Duration(hours: 6);
    final date = DateComponents(2020, 6, 12);
    final params = CalculationMethod.karachi.getParameters();
    params.madhab = Madhab.hanafi;

    final prayerTimes =
        PrayerTimes(kushtia, date, params, utcOffset: kushtiaUtcOffset);

    expect(DateFormat.jm().format(prayerTimes.timeForPrayer(Prayer.fajr)),
        '3:48 AM');
    expect(DateFormat.jm().format(prayerTimes.timeForPrayer(Prayer.sunrise)),
        '5:16 AM');
    expect(DateFormat.jm().format(prayerTimes.timeForPrayer(Prayer.dhuhr)),
        '12:04 PM');
    expect(DateFormat.jm().format(prayerTimes.timeForPrayer(Prayer.asr)),
        '4:44 PM');
    expect(DateFormat.jm().format(prayerTimes.timeForPrayer(Prayer.maghrib)),
        '6:51 PM');
    expect(DateFormat.jm().format(prayerTimes.timeForPrayer(Prayer.isha)),
        '8:19 PM');
  });

  test('Test PrayerTimes.currentPrayerByDateTime', () {
    final kushtia = Coordinates(23.9088, 89.1220);
    final kushtiaUtcOffset = Duration(hours: 6);
    final date = DateComponents(2020, 6, 12);
    final params = CalculationMethod.karachi.getParameters();
    params.madhab = Madhab.hanafi;

    final prayerTimes =
        PrayerTimes(kushtia, date, params, utcOffset: kushtiaUtcOffset);

    expect(prayerTimes.currentPrayerByDateTime(prayerTimes.fajr), Prayer.fajr);
    expect(prayerTimes.currentPrayerByDateTime(prayerTimes.sunrise),
        Prayer.sunrise);
    expect(
        prayerTimes.currentPrayerByDateTime(prayerTimes.dhuhr), Prayer.dhuhr);
    expect(prayerTimes.currentPrayerByDateTime(prayerTimes.asr), Prayer.asr);
    expect(prayerTimes.currentPrayerByDateTime(prayerTimes.maghrib),
        Prayer.maghrib);
    expect(prayerTimes.currentPrayerByDateTime(prayerTimes.isha), Prayer.isha);
  });

  test('Test PrayerTimes.nextPrayerByDateTime', () {
    final kushtia = Coordinates(23.9088, 89.1220);
    final kushtiaUtcOffset = Duration(hours: 6);
    final date = DateComponents(2020, 6, 12);
    final params = CalculationMethod.karachi.getParameters();
    params.madhab = Madhab.hanafi;

    final prayerTimes =
        PrayerTimes(kushtia, date, params, utcOffset: kushtiaUtcOffset);

    expect(prayerTimes.nextPrayerByDateTime(prayerTimes.fajr), Prayer.sunrise);
    expect(prayerTimes.nextPrayerByDateTime(prayerTimes.sunrise), Prayer.dhuhr);
    expect(prayerTimes.nextPrayerByDateTime(prayerTimes.dhuhr), Prayer.asr);
    expect(prayerTimes.nextPrayerByDateTime(prayerTimes.asr), Prayer.maghrib);
    expect(prayerTimes.nextPrayerByDateTime(prayerTimes.maghrib), Prayer.isha);
    expect(prayerTimes.nextPrayerByDateTime(prayerTimes.isha), Prayer.none);
  });

  test('Test PrayerTimes.today', () {
    final kushtia = Coordinates(23.9088, 89.1220);
    final kushtiaUtcOffset = Duration(hours: 6);
    final params = CalculationMethod.karachi.getParameters();
    params.madhab = Madhab.hanafi;

    final prayerTimes =
        PrayerTimes.today(kushtia, params, utcOffset: kushtiaUtcOffset);

    final now = DateTime.now().toUtc().add(kushtiaUtcOffset);
    expect(prayerTimes.dateComponents,
        DateComponents(now.year, now.month, now.day));
    expect(prayerTimes.fajr.day, now.day);
    expect(prayerTimes.sunrise.day, now.day);
    expect(prayerTimes.dhuhr.day, now.day);
    expect(prayerTimes.asr.day, now.day);
    expect(prayerTimes.maghrib.day, now.day);
    expect(prayerTimes.isha.day, now.day);
  });

  test('Test PrayerTimes.utc', () {
    final kushtia = Coordinates(23.9088, 89.1220);
    final date = DateComponents(2020, 6, 12);
    final params = CalculationMethod.karachi.getParameters();
    params.madhab = Madhab.hanafi;

    final prayerTimes = PrayerTimes.utc(kushtia, date, params);

    expect(prayerTimes.fajr.isUtc, true);
    expect(prayerTimes.sunrise.isUtc, true);
    expect(prayerTimes.dhuhr.isUtc, true);
    expect(prayerTimes.asr.isUtc, true);
    expect(prayerTimes.maghrib.isUtc, true);
    expect(prayerTimes.isha.isUtc, true);
  });

  test('Test Prayer Time in NewYork with utcOffset Factory', () {
    // with custom timezone UTC Offset.

    final newYork = Coordinates(35.7750, -78.6336);
    final nyUtcOffset = Duration(hours: -4);
    final nyDate = DateComponents(2015, 7, 12);
    final nyParams = CalculationMethod.north_america.getParameters();
    nyParams.madhab = Madhab.hanafi;
    final nyPrayerTimes =
        PrayerTimes.utcOffset(newYork, nyDate, nyParams, nyUtcOffset);

    expect(DateFormat.jm().format(nyPrayerTimes.fajr), '4:42 AM');
    expect(DateFormat.jm().format(nyPrayerTimes.sunrise), '6:08 AM');
    expect(DateFormat.jm().format(nyPrayerTimes.dhuhr), '1:21 PM');
    expect(DateFormat.jm().format(nyPrayerTimes.asr), '6:22 PM');
    expect(DateFormat.jm().format(nyPrayerTimes.maghrib), '8:32 PM');
    expect(DateFormat.jm().format(nyPrayerTimes.isha), '9:57 PM');
  });

  test('Test Prayer Times in Wide Range Locations From JSON Data.', () async {
    await initializeTimeZone();

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
        final locationTz = getLocation(params['timezone']);

        times.forEach((time) {
          final date = DateTime.tryParse(time['date']);
          if (date != null) {
            final prayerTimes = PrayerTimes(
                coordinates, DateComponents.from(date), calculationParams);

            final actualFajr = TZDateTime.from(prayerTimes.fajr, locationTz);
            final actualSunrise =
                TZDateTime.from(prayerTimes.sunrise, locationTz);
            final actualDhuhr = TZDateTime.from(prayerTimes.dhuhr, locationTz);
            final actualAsr = TZDateTime.from(prayerTimes.asr, locationTz);
            final actualMaghrib =
                TZDateTime.from(prayerTimes.maghrib, locationTz);
            final actualIsha = TZDateTime.from(prayerTimes.isha, locationTz);

            if (variance == null) {
              expect(DateFormat.jm().format(actualFajr), time['fajr']);
              expect(DateFormat.jm().format(actualSunrise), time['sunrise']);
              expect(DateFormat.jm().format(actualDhuhr), time['dhuhr']);
              expect(DateFormat.jm().format(actualAsr), time['asr']);
              expect(DateFormat.jm().format(actualMaghrib), time['maghrib']);
              expect(DateFormat.jm().format(actualIsha), time['isha']);
            } else {
              // Couldn't Implement, Because Couldn't Parse Time in Different Timezone From String.
//              final expectedFajr = TZDateTime.from(DateFormat('y-d-m h:m')
//                  .parse('${time['date']} ${time['fajr']}'), locationTz);
////              final expectedSunrise = DateFormat.yMd()
////                  .add_jm()
////                  .parse('${dateString} ${time['sunrise']}');
////              final expectedDhuhr = DateFormat.yMd()
////                  .add_jm()
////                  .parse('${dateString} ${time['dhuhr']}');
////              final expectedAsr = DateFormat.yMd()
////                  .add_jm()
////                  .parse('${dateString} ${time['asr']}');
////              final expectedMaghrib = DateFormat.yMd()
////                  .add_jm()
////                  .parse('${dateString} ${time['maghrib']}');
////              final expectedIsha = DateFormat.yMd()
////                  .add_jm()
////                  .parse('${dateString} ${time['isha']}');
//              print(actualFajr.difference(expectedFajr).inMinutes);
//              expect(actualFajr.difference(expectedFajr).inMinutes <= variance, isTrue);
            }
          }
        });
      }
    });
  });

  test('Test PrayerTimes.currentPrayer', () {
    final newYork = Coordinates(35.7750, -78.6336);
    final prayerTimes = PrayerTimes.today(
        newYork, CalculationMethod.north_america.getParameters());
    expect(prayerTimes.currentPrayer() is Prayer, true);
  });

  test('Test PrayerTimes.nextPrayer', () {
    final newYork = Coordinates(35.7750, -78.6336);
    final prayerTimes = PrayerTimes.today(
        newYork, CalculationMethod.north_america.getParameters());
    expect(prayerTimes.nextPrayer() is Prayer, true);
  });

  test('Test PrayerTimes MOON_SIGHTING_COMMITTEE and Latitude Greater Than 55',
      () {
    final newYork = Coordinates(55.7750, -78.6336);
    final prayerTimes = PrayerTimes.today(
        newYork, CalculationMethod.moon_sighting_committee.getParameters());
    print(prayerTimes.fajr);
  });

  test('Test PrayerTimes Invalid Coordinates', () {
    final invalidCoordinates = Coordinates(90.7750, -78.6336);
    final prayerTimes = PrayerTimes.today(
        invalidCoordinates, CalculationMethod.karachi.getParameters());
    expect(prayerTimes.fajr, null);
    expect(prayerTimes.sunrise, null);
    expect(prayerTimes.dhuhr, null);
    expect(prayerTimes.asr, null);
    expect(prayerTimes.maghrib, null);
    expect(prayerTimes.isha, null);
  });

  test('Test PrayerTimes.daysSinceSolstice', () {
    _daysSinceSolsticeTest(
        11, /* year */ 2016, /* month */ 1, /* day */ 1, /* latitude */ 1);
    _daysSinceSolsticeTest(
        10, /* year */ 2015, /* month */ 12, /* day */ 31, /* latitude */ 1);
    _daysSinceSolsticeTest(
        10, /* year */ 2016, /* month */ 12, /* day */ 31, /* latitude */ 1);
    _daysSinceSolsticeTest(
        0, /* year */ 2016, /* month */ 12, /* day */ 21, /* latitude */ 1);
    _daysSinceSolsticeTest(
        1, /* year */ 2016, /* month */ 12, /* day */ 22, /* latitude */ 1);
    _daysSinceSolsticeTest(
        71, /* year */ 2016, /* month */ 3, /* day */ 1, /* latitude */ 1);
    _daysSinceSolsticeTest(
        70, /* year */ 2015, /* month */ 3, /* day */ 1, /* latitude */ 1);
    _daysSinceSolsticeTest(
        365, /* year */ 2016, /* month */ 12, /* day */ 20, /* latitude */ 1);
    _daysSinceSolsticeTest(
        364, /* year */ 2015, /* month */ 12, /* day */ 20, /* latitude */ 1);

    _daysSinceSolsticeTest(
        0, /* year */ 2015, /* month */ 6, /* day */ 21, /* latitude */ -1);
    _daysSinceSolsticeTest(
        0, /* year */ 2016, /* month */ 6, /* day */ 21, /* latitude */ -1);
    _daysSinceSolsticeTest(
        364, /* year */ 2015, /* month */ 6, /* day */ 20, /* latitude */ -1);
    _daysSinceSolsticeTest(
        365, /* year */ 2016, /* month */ 6, /* day */ 20, /* latitude */ -1);
  });
}

void _daysSinceSolsticeTest(
    int value, int year, int month, int day, double latitude) {
  // For Northern Hemisphere start from December 21
  // (DYY=0 for December 21, and counting forward, DYY=11 for January 1 and so on).
  // For Southern Hemisphere start from June 21
  // (DYY=0 for June 21, and counting forward)
  final date = CalendarUtil.resolveTime(year, month, day);
  expect(PrayerTimes.daysSinceSolstice(date.dayOfYear, date.year, latitude),
      value);
}
