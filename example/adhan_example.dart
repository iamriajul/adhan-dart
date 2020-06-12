import 'package:adhan/src/calculation_method.dart';
import 'package:adhan/src/coordinates.dart';
import 'package:adhan/src/data/date_components.dart';
import 'package:adhan/src/madhab.dart';
import 'package:adhan/src/prayer_times.dart';
import 'package:intl/intl.dart';

void main() {
  print('NewYork Prayer Times');
  final kushtia = Coordinates(23.9088, 89.1220);
  final date = DateComponents(2020, 6, 12);
  final params = CalculationMethod.karachi.getParameters();
  params.madhab = Madhab.hanafi;
  final prayerTimes = PrayerTimes(Duration(hours: 6), kushtia, date, params);

  print(DateFormat.jm().format(prayerTimes.fajr));
  print(DateFormat.jm().format(prayerTimes.sunrise));
  print(DateFormat.jm().format(prayerTimes.dhuhr));
  print(DateFormat.jm().format(prayerTimes.asr));
  print(DateFormat.jm().format(prayerTimes.maghrib));
  print(DateFormat.jm().format(prayerTimes.isha));

  print('---');

  print('NewYork Prayer Times');
  final newYork = Coordinates(35.7750, -78.6336);
  final nyDate = DateComponents(2015, 7, 12);
  final nyParams = CalculationMethod.north_america.getParameters();
  nyParams.madhab = Madhab.hanafi;
  final nyPrayerTimes = PrayerTimes(Duration(hours: -4), newYork, nyDate, nyParams);

  print(DateFormat.jm().format(nyPrayerTimes.fajr));
  print(DateFormat.jm().format(nyPrayerTimes.sunrise));
  print(DateFormat.jm().format(nyPrayerTimes.dhuhr));
  print(DateFormat.jm().format(nyPrayerTimes.asr));
  print(DateFormat.jm().format(nyPrayerTimes.maghrib));
  print(DateFormat.jm().format(nyPrayerTimes.isha));
}
