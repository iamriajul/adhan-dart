import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'package:timezone/standalone.dart';

void main() async {
  // Load timezone data
  await initializeTimeZone();

  generate(
    name: 'Kushtia-Karachi-Hanafi-Generated-Using-V1',
    coordinates: Coordinates(23.9088, 89.1220),
    timezone: 'Asia/Dhaka',
    parameters: CalculationMethod.karachi.getParameters()
      ..madhab = Madhab.hanafi,
    dates: generateDates(
      from: DateTime(2021, 1, 1),
      to: DateTime(2022, 1, 1),
    ),
  );

  /// Generate 1000 random dates within last 30 years
  final randomDates = <DateTime>[];
  final random = Random();
  for (var i = 0; i < 1000; i++) {
    final year = random.nextInt(30) + 1990;
    final month = random.nextInt(12) + 1;
    final day = random.nextInt(28) + 1;
    randomDates.add(DateTime(year, month, day));
  }

  generate(
    name: 'Kushtia-Karachi-Hanafi-Random-Dates-Generated-Using-V1',
    coordinates: Coordinates(23.9088, 89.1220),
    timezone: 'Asia/Dhaka',
    parameters: CalculationMethod.karachi.getParameters()
      ..madhab = Madhab.hanafi,
    dates: randomDates,
  );

  generate(
    name: 'NewYork-NorthAmerica-Hanafi-Generated-Using-V1',
    coordinates: Coordinates(35.7750, -78.6336),
    timezone: 'America/New_York',
    parameters: CalculationMethod.north_america.getParameters()
      ..madhab = Madhab.hanafi,
    dates: generateDates(
      from: DateTime(2021, 1, 1),
      to: DateTime(2022, 1, 1),
    ),
  );
}

List<DateTime> generateDates({
  DateTime from,
  DateTime to
}) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);

  assert(from.isBefore(to));

  final dates = <DateTime>[];

  var date = from;
  while (date.isBefore(to)) {
    dates.add(date);
    date = date.add(Duration(days: 1));
  }

  return dates;
}

void generate({
  String name,
  Coordinates coordinates,
  String timezone,
  CalculationParameters parameters,
  List<DateTime> dates,
}) {
  // Get the timezone object using the timezone name
  final location = getLocation(timezone);

  final times = dates.map((date) {
    final prayerTimes = PrayerTimes(
      coordinates,
      DateComponents.from(date),
      parameters,
    );

    final fajr = TZDateTime.from(prayerTimes.fajr, location);
    final sunrise = TZDateTime.from(prayerTimes.sunrise, location);
    final dhuhr = TZDateTime.from(prayerTimes.dhuhr, location);
    final asr = TZDateTime.from(prayerTimes.asr, location);
    final maghrib = TZDateTime.from(prayerTimes.maghrib, location);
    final isha = TZDateTime.from(prayerTimes.isha, location);

    return {
      'date': DateFormat('yyyy-MM-dd').format(date),
      'fajr': DateFormat.jm().format(fajr),
      'sunrise': DateFormat.jm().format(sunrise),
      'dhuhr': DateFormat.jm().format(dhuhr),
      'asr': DateFormat.jm().format(asr),
      'maghrib': DateFormat.jm().format(maghrib),
      'isha': DateFormat.jm().format(isha),
    };
  }).toList();

  // write to file
  final file = File('test/data/prayer-times/$name.json');
  file.writeAsStringSync(JsonEncoder.withIndent('  ').convert({
    'params': {
      'latitude': coordinates.latitude,
      'longitude': coordinates.longitude,
      'timezone': timezone,
      'method': parameters.method.name,
      'madhab': parameters.madhab.name,
      'highLatitudeRule': parameters.highLatitudeRule.name,
    },
    'variance': null,
    'times': times,
  }));
}
