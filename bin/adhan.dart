import 'dart:convert';

import 'dart:io';

import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

void main() {
  print(
      'Adhan for Dart / Muslim Prayer Times Library. Now retrieving Prayer time in Dart easier than ever.');
  print('What is your Latitude?');
  var lat = stdin.readLineSync(encoding: Encoding.getByName('utf-8'));
  print('What is your Longitude?');
  var lng = stdin.readLineSync(encoding: Encoding.getByName('utf-8'));

  final coordinates = Coordinates(double.parse(lat), double.parse(lng));
  final params = CalculationMethod.karachi.getParameters();
  params.madhab = Madhab.hanafi;

  final prayerTimes =
      PrayerTimes(coordinates, DateComponents.from(DateTime.now()), params);

  print('--------------------------');
  print("---Today's Prayer Times---");
  print('Fajr: ${DateFormat.jm().format(prayerTimes.fajr)}');
  print('Sunrise: ${DateFormat.jm().format(prayerTimes.sunrise)}');
  print('Dhuhr: ${DateFormat.jm().format(prayerTimes.dhuhr)}');
  print('Asr: ${DateFormat.jm().format(prayerTimes.asr)}');
  print('Maghrib: ${DateFormat.jm().format(prayerTimes.maghrib)}');
  print('Isha: ${DateFormat.jm().format(prayerTimes.isha)}');
}
