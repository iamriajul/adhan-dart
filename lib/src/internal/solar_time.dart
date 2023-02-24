import 'dart:math';

import '../coordinates.dart';
import 'astronomical.dart';
import 'calendrical_helper.dart';
import 'math.dart';
import 'shadow_length.dart';
import 'solar_coordinates.dart';

class SolarTime {
  double? _transit;
  double? get transit => _transit;

  double? _sunrise;
  double? get sunrise => _sunrise;

  double? _sunset;
  double? get sunset => _sunset;

  Coordinates? _observer;
  SolarCoordinates? _solar;
  SolarCoordinates? _prevSolar;
  SolarCoordinates? _nextSolar;
  double? _approximateTransit;

  SolarTime(DateTime _today, Coordinates coordinates) {
    final today = _today;

    final tomorrow = today.add(Duration(days: 1));

    final yesterday = today.subtract(Duration(days: 1));

    _prevSolar = SolarCoordinates(CalendricalHelper.julianDayByDate(yesterday));
    _solar = SolarCoordinates(CalendricalHelper.julianDayByDate(today));
    _nextSolar = SolarCoordinates(CalendricalHelper.julianDayByDate(tomorrow));

    _approximateTransit = Astronomical.approximateTransit(coordinates.longitude,
        _solar!.apparentSiderealTime!, _solar!.rightAscension!);
    final solarAltitude = -50.0 / 60.0;

    _observer = coordinates;
    _transit = Astronomical.correctedTransit(
        _approximateTransit!,
        coordinates.longitude,
        _solar!.apparentSiderealTime!,
        _solar!.rightAscension!,
        _prevSolar!.rightAscension!,
        _nextSolar!.rightAscension!);
    _sunrise = Astronomical.correctedHourAngle(
        _approximateTransit!,
        solarAltitude,
        coordinates,
        false,
        _solar!.apparentSiderealTime!,
        _solar!.rightAscension!,
        _prevSolar!.rightAscension!,
        _nextSolar!.rightAscension!,
        _solar!.declination!,
        _prevSolar!.declination!,
        _nextSolar!.declination!);
    _sunset = Astronomical.correctedHourAngle(
        _approximateTransit!,
        solarAltitude,
        coordinates,
        true,
        _solar!.apparentSiderealTime!,
        _solar!.rightAscension!,
        _prevSolar!.rightAscension!,
        _nextSolar!.rightAscension!,
        _solar!.declination!,
        _prevSolar!.declination!,
        _nextSolar!.declination!);
  }

  double hourAngle(double angle, bool afterTransit) {
    return Astronomical.correctedHourAngle(
        _approximateTransit!,
        angle,
        _observer!,
        afterTransit,
        _solar!.apparentSiderealTime!,
        _solar!.rightAscension!,
        _prevSolar!.rightAscension!,
        _nextSolar!.rightAscension!,
        _solar!.declination!,
        _prevSolar!.declination!,
        _nextSolar!.declination!);
  }

  // hours from transit
  double afternoon(ShadowLength shadowLength) {
    // TODO (from Swift version) source shadow angle calculation
    final tangent = (_observer!.latitude - _solar!.declination!).abs();
    final inverse = shadowLength.getShadowLength() + tan(radians(tangent));
    final angle = degrees(atan(1.0 / inverse));

    return hourAngle(angle, true);
  }
}
