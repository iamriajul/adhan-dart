import 'dart:convert';

import 'dart:io';

import 'package:adhan/adhan.dart';

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

  final prayerTimes = PrayerTimes.today(coordinates, params);

  final hr =
      '-----------------------------------------------------------------------------------';
  print(hr);
  print(
      "---Today's Prayer Times in Your Local Timezone(${prayerTimes.fajr.timeZoneName})---");
  print('Fajr: ${prayerTimes.fajr}');
  print('Sunrise: ${prayerTimes.sunrise}');
  print('Dhuhr: ${prayerTimes.dhuhr}');
  print('Asr: ${prayerTimes.asr}');
  print('Maghrib: ${prayerTimes.maghrib}');
  print('Isha: ${prayerTimes.isha}');

  final sunnahTimes = SunnahTimes(prayerTimes);
  print(hr);
  print('Middle Of The Night: ${sunnahTimes.middleOfTheNight}');
  print('Last Third Of The Night: ${sunnahTimes.lastThirdOfTheNight}');

  final qibla = Qibla(coordinates);
  print(hr);
  print('Qibla: ${qibla.direction}');
}
